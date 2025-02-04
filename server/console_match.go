// Copyright 2018 The Nakama Authors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

package server

import (
	"context"
	"strings"

	"github.com/talktonpc/nakama-common/runtime"

	"github.com/gofrs/uuid"
	"github.com/talktonpc/nakama-common/api"
	"github.com/talktonpc/nakama/v3/console"
	"go.uber.org/zap"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (s *ConsoleServer) ListMatches(ctx context.Context, in *api.ListMatchesRequest) (*api.MatchList, error) {
	limit := 10
	if in.GetLimit() != nil {
		if in.GetLimit().Value < 1 || in.GetLimit().Value > 100 {
			return nil, status.Error(codes.InvalidArgument, "Invalid limit - limit must be between 1 and 100.")
		}
		limit = int(in.GetLimit().Value)
	}

	if in.Label != nil && (in.Authoritative != nil && !in.Authoritative.Value) {
		return nil, status.Error(codes.InvalidArgument, "Label filtering is not supported for non-authoritative matches.")
	}
	if in.Query != nil && (in.Authoritative != nil && !in.Authoritative.Value) {
		return nil, status.Error(codes.InvalidArgument, "Query filtering is not supported for non-authoritative matches.")
	}

	if in.MinSize != nil && in.MinSize.Value < 0 {
		return nil, status.Error(codes.InvalidArgument, "Minimum size must be 0 or above.")
	}
	if in.MaxSize != nil && in.MaxSize.Value < 0 {
		return nil, status.Error(codes.InvalidArgument, "Maximum size must be 0 or above.")
	}
	if in.MinSize != nil && in.MaxSize != nil && in.MinSize.Value > in.MaxSize.Value {
		return nil, status.Error(codes.InvalidArgument, "Maximum size must be greater than or equal to minimum size when both are specified.")
	}

	results, err := s.matchRegistry.ListMatches(ctx, limit, in.Authoritative, in.Label, in.MinSize, in.MaxSize, in.Query)
	if err != nil {
		s.logger.Error("Error listing matches", zap.Error(err))
		return nil, status.Error(codes.Internal, "Error listing matches.")
	}

	return &api.MatchList{Matches: results}, nil
}

func (s *ConsoleServer) GetMatchState(ctx context.Context, in *console.MatchStateRequest) (*console.MatchState, error) {
	// Validate the match ID.
	matchIDComponents := strings.SplitN(in.GetId(), ".", 2)
	if len(matchIDComponents) != 2 {
		return nil, status.Error(codes.InvalidArgument, "Invalid match ID.")
	}
	matchID, err := uuid.FromString(matchIDComponents[0])
	if err != nil {
		return nil, status.Error(codes.InvalidArgument, "Invalid match ID.")
	}
	node := matchIDComponents[1]
	if node == "" {
		// Relayed matches don't have a state.
		return &console.MatchState{State: ""}, nil
	}

	presences, tick, state, err := s.matchRegistry.GetState(ctx, matchID, node)
	if err != nil {
		if err != context.Canceled && err != runtime.ErrMatchNotFound {
			s.logger.Error("Error getting match state.", zap.Any("in", in), zap.Error(err))
		}
		if err == runtime.ErrMatchNotFound {
			return nil, status.Error(codes.InvalidArgument, "Match not found, or match handler already stopped.")
		}
		return nil, status.Error(codes.Internal, "Error listing matches.")
	}

	return &console.MatchState{Presences: presences, Tick: tick, State: state}, nil
}
