local nk = require("nakama")
local d = require("debug")

local function MatchCreate(context, payload)
    nk.logger_info("MatchCreate ===========================")
    nk.logger_info(d.dump(context))
    nk.logger_info(d.dump(payload))

    return payload
end
nk.register_rt_before(MatchCreate, "MatchCreate")
nk.register_rt_after(MatchCreate, "MatchCreate")

local function ListMatches(context, payload)
    nk.logger_info("ListMatches ===========================")
    nk.logger_info(d.dump(context))
    nk.logger_info(d.dump(payload))

    return payload
end

nk.register_req_before(ListMatches, "ListMatches")
nk.register_req_after(ListMatches, "ListMatches")