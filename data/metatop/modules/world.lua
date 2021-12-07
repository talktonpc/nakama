local nk = require("nakama")
local debug = require("debug")

local world = {}
local commands = {}

local Operations = {
    op_state = 1,
    op_location = 2,
    op_input = 3,
    op_pose = 4,
    op_item = 5,
    op_spawn = 6
}

local Pose = {
    idle = 0,
    stand = 1,
    walk = 2,
    run = 3,
    seat = 4
}

local SPAWN_POSITION = {-9.01, 0.0, -3.02}

commands[Operations.op_state] = function(data, state)
end

commands[Operations.op_location] = function(data, state)
    -- nk.logger_info(debug.dump(data));
    -- nk.logger_info(debug.dump(state));

    local id = data.id
    local location = data
    if state.locations[id] ~= nil then
        state.locations[id].x = location.x
        state.locations[id].y = location.y
        state.locations[id].z = location.z
    end
end

commands[Operations.op_input] = function(data, state)
    local id = data.id
    local input = data
    if state.inputs[id] ~= nil then
        state.inputs[id].direction = input.direction
        state.inputs[id].jump = input.jump
    end
end

commands[Operations.op_pose] = function(data, state)
    local id = data.id
    if state.poses[id] ~= nil then
        state.poses[id] = data.pose
    end
end

function world.match_init(context, state)
    local tickrate = state["tickrate"]
    local label = state["label"]

    return state, tickrate, label
end

function world.match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    if state.presences[presence.session_id] ~= nil then
        return state, false, "User already logged in."
    end
    return state, true
end

function world.match_join(context, dispatcher, tick, state, presences)
    -- nk.logger_info(debug.dump(context));
    -- nk.logger_info(debug.dump(state));
    -- nk.logger_info(debug.dump(presences));

    for _, presence in ipairs(presences) do
        local id = presence.session_id
        state.presences[id] = presence
        state.locations[id] = {
            ["x"] = SPAWN_POSITION[1],
            ["y"] = SPAWN_POSITION[2],
            ["z"] = SPAWN_POSITION[3]
        }
        state.inputs[id] = {
            ["direction"] = 0,
            ["jump"] = 0
        }
        state.poses[id] = Pose.stand
    end

    -- nk.logger_info(debug.dump(state));

    return state
end

function world.match_leave(context, dispatcher, tick, state, presences)
    for _, presence in ipairs(presences) do
        local id = presence.user_id
        -- local new_objects = {
        --     {
        --         collection = "player_data",
        --         key = "location_" .. id,
        --         user_id = id,
        --         value = state.locations[id]
        --     }
        -- }
        -- nk.storage_write(new_objects)

        state.presences[id] = nil
        state.locations[id] = nil
        state.poses[id] = nil
        state.inputs[id] = nil
        state.items[id] = nil
    end

    return state
end

function world.match_loop(context, dispatcher, tick, state, messages)
    for _, message in ipairs(messages) do

        -- nk.logger_info(debug.dump(context));
        -- nk.logger_info(debug.dump(state));
        -- nk.logger_info(debug.dump(messages));

        local op = message.op_code

        if op == nil then
            return status
        end

        local command = commands[op]
        if command ~= nil then
            local decoded = nk.json_decode(message.data)
            commands[op](decoded, state)
        else
            return status
        end

        if op == Operations.op_state then
        end

        if op == Operations.op_location then
            local data = {
                ["locations"] = state.locations
            }

            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(Operations.op_location, encoded)
        end

        if op == Operations.op_input then
            local data = {
                ["inputs"] = state.inputs
            }
        
            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(Operations.op_input, encoded)
        end

        if op == Operations.op_pose then
            local data = {
                ["poses"] = state.poses
            }
        
            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(Operations.op_pose, encoded)
        end

        if op == Operations.op_item then
            local data = {
                ["poses"] = state.items
            }
        
            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(Operations.op_item, encoded)
        end

        if op == Operations.op_spawn then
            local object_ids = {
                {
                    collection = "player_data",
                    key = "location_" .. decoded.nm,
                    session_id = message.sender.session_id
                }
            }

            local objects = nk.storage_read(object_ids)

            local location
            for _, object in ipairs(objects) do
                location = object.value
                if location ~= nil then
                    state.locations[message.sender.session_id] = location
                    break
                end
            end

            if location == nil then
                state.locations[message.sender.session_id] = {
                    ["x"] = SPAWN_POSITION[1],
                    ["y"] = SPAWN_POSITION[2],
                    ["z"] = SPAWN_POSITION[3],
                }
            end

            local data = {
                ["location"] = state.locations,
                ["input"] = state.inputs,
                ["col"] = state.items,
            }

            local encoded = nk.json_encode(data)
            dispatcher.broadcast_message(Operations.op_spawn, message.data)
        end
    end

    for _, input in pairs(state.inputs) do
        input.jump = 0
    end

    return state
end

function world.match_terminate(context, dispatcher, tick, state, grace_seconds)
    nk.logger_info("match_terminate ===========================")

    -- local new_objects = {}
    -- for k, location in pairs(state.locations) do
    --     table.insert(
    --         new_objects,
    --         {
    --             collection = "player_data",
    --             key = "location_" .. state.names[k],
    --             session_id = k,
    --             value = location
    --         }
    --     )
    -- end

    -- nk.storage_write(new_objects)

    return state
end

function world.match_signal(context, dispatcher, tick, state, data)
    nk.logger_info("match_signal ===========================")

    return state, data
end

return world