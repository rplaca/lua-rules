-- Lua Rules : A forward chaining rete rules engine

local M = {}

M.fact_list = {}
M.assert = function (...)
    args = {...}
    for _, fact in ipairs(args) do
        table.insert(M.fact_list, fact)
    end
    
    return true
end

M.retract = function (fact)
    table.remove(M.fact_list, 1)
    return true
end

M.clear = function ()
    M.fact_list = {}
    return true
end

return M