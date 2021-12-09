/*
 * Copyright 2021 The Nakama Authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

-- +migrate Up
DROP TABLE IF EXISTS tbl_scences;

-- ================================================================================================================
-- Added for MetaTop extension (2021-12-09, lonycell)
-- ================================================================================================================
CREATE TABLE IF NOT EXISTS tbl_scences (
    PRIMARY KEY (id),

    id      INTEGER         NOT NULL UNIQUE CHECK (id >= 0),
    type    SMALLINT        NOT NULL DEFAULT 0 CHECK (type >= 0), -- city(0), building(1), room(2), interior(3)
    name    VARCHAR(255)    NOT NULL UNIQUE,
    title   VARCHAR(255)    NOT NULL,
    address VARCHAR(255),
    thumb   VARCHAR(255),
    minimap VARCHAR(255),
    scale   float(2) DEFAULT 1.0 CHECK (scale >= 0.0),
    create_time TIMESTAMPTZ  NOT NULL DEFAULT now(),
    update_time TIMESTAMPTZ  NOT NULL DEFAULT now()
);

-- +migrate Down
DROP TABLE IF EXISTS
    tbl_scences;