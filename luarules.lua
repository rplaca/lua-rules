-- Lua Rules : A forward chaining rete rules engine

local inspect = require('inspect')

local M = {}

local fact_list = {}
local watch_list = { facts = false }

--[[
The assert function adds one or more facts to the fact-list.
--]]
M.assert = function (...)
    args = {...}
    for _, fact in ipairs(args) do
        table.insert(fact_list, fact)
        if watch_list.facts == true then
            print("==> " .. inspect(fact))
        end
    end
    
    return true
end

--[[
The retract function deletes one or more facts from the fact-list.
--]]
M.retract = function (...)
    local args = {...}
    local return_value = false

    for _, fact in ipairs(args) do
        for i = 1, #fact_list do -- XXX let's remember to index the facts
            -- so that we don't have to iterate the fact_list for each one  
            if fact_list[i] == fact then
                table.remove(fact_list, i)
                return_value = true
                break
            end
        end
    end

    return return_value
end

--[[
The clear function deletes all facts from the fact-list.
--]]
M.clear = function ()
    fact_list = {}
    
    return true
end

--[[
The facts function returns the fact-list.
--]]
M.facts = function ()
    return fact_list
end

M.watch = function (watch_item)
    if watch_list[watch_item] ~= nil then
        watch_list[watch_item] = true
        return true
    end
    return false
end

return M