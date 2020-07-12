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

M.retract = function (...)
    local args = {...}
    local return_value = false
    for _, fact in ipairs(args) do
        for i = 1, #M.fact_list do
            if M.fact_list[i] == fact then
                table.remove(M.fact_list, i)
                return_value = true
                break
            end
        end
    end

    return return_value
end

M.clear = function ()
    M.fact_list = {}
    return true
end

return M