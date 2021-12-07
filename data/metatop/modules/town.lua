local nk = require("nakama")
local town = {}

function town.match_init(context, state)
    nk.logger_info("match_init ===========================")

    local tickrate = state["tickrate"]
    local label = state["label"]

    return state, tickrate, label
end

function town.match_join_attempt(context, dispatcher, tick, state, presence, metadata)
    nk.logger_info("match_join_attempt ===========================")

    local acceptuser = true

    return state, acceptuser
end

function town.match_join(context, dispatcher, tick, state, presences)
    nk.logger_info("match_join ===========================")

    for _, presence in ipairs(presences) do
        state.presences[presence.session_id] = presence
    end

    return state
end

function town.match_leave(context, dispatcher, tick, state, presences)
    nk.logger_info("match_leave ===========================")

    for _, presence in ipairs(presences) do
        state.presences[presence.session_id] = nil
    end
    return state
end

function town.match_loop(context, dispatcher, tick, state, messages)
    for _, p in pairs(state.presences) do
        nk.logger_debug(string.format("Presence %s named %s", p.user_id, p.username))
    end
    for _, m in ipairs(messages) do
        nk.logger_debug(string.format("Received %s from %s", m.data, m.sender.username))
        local decoded = nk.json_decode(m.data)
        for k, v in pairs(decoded) do
            nk.logger_debug(string.format("Key %s contains value %s", k, v))
        end

        dispatcher.broadcast_message(1, m.data, { m.sender })
    end
    return state
end

function town.match_terminate(context, dispatcher, tick, state, grace_seconds)
    nk.logger_info("match_terminate ===========================")

    local message = "Server shutting down in " .. grace_seconds .. " seconds"
    dispatcher.broadcast_message(2, message)
    return nil
end

function town.match_signal(context, dispatcher, tick, state, data)
    nk.logger_info("match_signal ===========================")

    return state, "signal received: " .. data
end

return town