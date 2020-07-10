-- Lua Rules : A forward chaining rete rules engine

local M = {}

M.fact_list = {}
M.assert = function (fact)
    table.insert(M.fact_list, fact)
    return true
end

return M