-- Lua Rules : A forward chaining rete rules engine

local lu = require('luaunit')

function testHookup()
    lu.assertEquals(1, 1)
end

function testLuaRulesModule()
    lu.assertIsTable(require('luarules'))
end

function testLuaRulesClear()
    local lr = require('luarules')

    lu.assertTrue(lr.clear()) -- clearing the working memory should return true
    lu.assertEquals(#lr.fact_list, 0) -- and the fact-list should be empty
end

function testLuaRulesFactListCount()
    local lr = require('luarules')

    lu.assertTrue(lr.clear())
    lu.assertEquals(#lr.fact_list, 0) -- ensure the fact-list is empty
    local empty_fact = {} -- the fact_list works by reference so we need a variable
    lu.assertTrue(lr.assert(empty_fact)) -- asserting an empty table should return True
    lu.assertEquals(#lr.fact_list, 1) -- and the fact-list should have 1 fact

    lu.assertTrue(lr.retract(empty_fact)) -- retracting the fact should return True
    lu.assertEquals(#lr.fact_list, 0) -- and the fact-list should be empty again
    
    lu.assertTrue(lr.assert(empty_fact, empty_fact, empty_fact)) -- asserting three facts should work
    lu.assertEquals(#lr.fact_list, 3) -- and the fact-list should be three items long
    -- actually the above should only result in one fact (duplicates don't count), but
    -- I'm not going to worry about that for now.

    lu.assertTrue(lr.retract(empty_fact))
    lu.assertEquals(#lr.fact_list, 2) -- considering that we think of each of the
    -- empty tables as different this should result in a fact-list with two items in it
end

function testLuaRulesFactListFacts()
    local lr = require('luarules')

    lu.assertTrue(lr.clear())
    lu.assertEquals(#lr.fact_list, 0) -- this is going to bite me once I implement
    -- the initial-fact and make the fact_list variable private

    -- asserting two distinct facts and retracting one of them should leave one left
    local f, b = {'foo'}, {'bar'}
    lu.assertTrue(lr.assert(f, b))
    lu.assertTrue(lr.retract(b))
    lu.assertEquals(lr.fact_list, {{'foo'},})
end

os.exit(lu.LuaUnit.run())