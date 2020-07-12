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
    index = -1
    for i = 1, #M.fact_list do
        if M.fact_list[i] == fact then
            index = i
            break
        end
    end

    if index ~= -1 then
        table.remove(M.fact_list, index)
        return true
    end

    return false
end

M.clear = function ()
    M.fact_list = {}
    return true
end

return M