-- Lua Rules : A forward chaining rete rules engine

local inspect = require('inspect')

local M = {}

local fact_list = {}
local agenda = {}
local initial_facts = {}
local watch_list = { facts = false }

local rule_list = {}
local working_memory = {}

local root_node = {}
root_node.add = function (fact)
    for rule, pattern in pairs(working_memory) do
        if inspect(fact) == inspect(pattern) then
            table.insert(agenda, {rule, fact})
        end
    end
end

--[[
The deffacts function adds one or more facts as "initial facts" in a named
set. When the reset function is called, every fact specified within a
deffacts construct is added to the fact-list.
--]]
M.deffacts = function (name, ...)
    initial_facts[name] = {...}
    return true
end

--[[
The defrule function is used to construct rules. The LHS is made up of
conditional elements matched against the fact-list and the RHS should always
be a function definition which will be called if the LHS matches.
--]]
M.defrule = function (name, lhs, rhs)
    working_memory[name] = lhs
    rule_list[name] = rhs
    return true
end

--[[
The assert function adds one or more facts to the fact-list.
--]]
M.assert = function (...)
    args = {...}
    for _, fact in ipairs(args) do
        table.insert(fact_list, fact)
        root_node.add(fact)
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
                if watch_list.facts == true then
                    print("<== " .. inspect(fact))
                end
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
The reset function deletes all facts from the fact-list and
removes all activations from the agenda.
--]]
M.reset = function ()
    -- retract all facts from the fact-list
    for i = 1, #fact_list do
        M.retract(fact_list[i])
    end

    -- and assert all initial facts (defined with deffacts)
    for name, facts in pairs(initial_facts) do
        for _, fact in ipairs(facts) do
            M.assert(fact)
        end
    end

    return true
end

--[[
The run function starts the execution of the rules. 
--]]
M.run = function ()
    return true
end

--[[
The facts function returns the fact-list.
--]]
M.facts = function ()
    return fact_list
end

--[[
The agenda function returns the agenda.
--]]
M.agenda = function ()
    return agenda
end

--[[
The watch function prints to stdout when certain operations take place. If
facts are watched, all fact assertions and retractions will be displayed.
--]]
M.watch = function (watch_item)
    if watch_list[watch_item] ~= nil then
        watch_list[watch_item] = true
        return true
    end
    return false
end

M.unwatch = function (watch_item)
    if watch_list[watch_item] ~= nil then
        watch_list[watch_item] = false
        return true
    end
    return false
end

return M