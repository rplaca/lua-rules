-- Lua Rules : A forward chaining rete rules engine

local lu = require('luaunit')

--[[ 
    add a `lu.assertPrints(function () return <exp> end, <string>)` that return
    whatever <exp> returns, hopefully simplifying a few tests in the progress.

    NOTE! In order to capture the printed output of <exp> we're going to have
    to 1) defer the execution of it so that we can 2) temporarily modify the
    `print` function to capture whatever is printed.
--]]

local fexp_prints = ""
lu.assertPrints = function (fexp, expected)
    local _print = print
    local fexp_result
    print = function (...)
        fexp_prints = fexp_prints .. ... .. '\n' end
    fexp_result = fexp()
    print = _print

    if expected then lu.assertStrMatches(fexp_prints:sub(1,-2), expected) end
    fexp_prints = ""
    return fexp_result
end

--[[
    Sanity tests. If either of these fail, something is horribly wrong.
--]]
function testHookup()
    lu.assertEquals(1, 1)
end

function testLuaRulesModule()
    lu.assertIsTable(require('luarules'))
end

--[[
    Actual tests begin here.
--]]
function testLuaRulesClear()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts')) -- unwatch facts should return true
    lu.assertFalse(lr.unwatch('fats')) -- unwatch fats should return false

    lu.assertTrue(lr.clear()) -- clearing the working memory should return true
    lu.assertEquals(#lr.facts(), 0) -- and the fact-list should be empty
end

function testLuaRulesFactListCount()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts'))
    lu.assertTrue(lr.clear())

    lu.assertEquals(#lr.facts(), 0) -- ensure the fact-list is empty
    local empty_fact = {} -- the fact_list works by reference so we need a variable
    lu.assertTrue(lr.assert(empty_fact)) -- asserting an empty table should return True
    lu.assertEquals(#lr.facts(), 1) -- and the fact-list should have 1 fact

    lu.assertTrue(lr.retract(empty_fact)) -- retracting the fact should return True
    lu.assertEquals(#lr.facts(), 0) -- and the fact-list should be empty again
    
    lu.assertTrue(lr.assert(empty_fact, empty_fact, empty_fact)) -- asserting three facts should work
    lu.assertEquals(#lr.facts(), 3) -- and the fact-list should be three items long
    -- actually the above should only result in one fact (duplicates don't count), but
    -- I'm not going to worry about that for now. XXX decide on duplicates

    lu.assertTrue(lr.retract(empty_fact))
    lu.assertEquals(#lr.facts(), 2) -- considering that we think of each of the
    -- empty tables as different this should result in a fact-list with two items in it
end

function testLuaRulesFactListFacts()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts'))
    lu.assertTrue(lr.clear())

    lu.assertEquals(#lr.facts(), 0) -- this is going to bite me once I implement
    -- the initial-fact XXX

    -- asserting two distinct facts and retracting one of them should leave one left
    local f, b = {'foo'}, {'bar'}
    lu.assertTrue(lr.assert(f, b))
    lu.assertTrue(lr.retract(b))
    lu.assertEquals(lr.facts(), {{'foo'},})

    lu.assertTrue(lr.clear()) -- clear the working memory and
    lu.assertTrue(lr.assert(f, b)) -- assert both facts again
    lu.assertTrue(lr.retract(f, b)) -- retracting two facts should work as well
    lu.assertEquals(#lr.facts(), 0)
end

function testLuaRulesWatchFacts()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts'))
    lu.assertTrue(lr.clear())

    lu.assertTrue(lr.watch('facts')) -- watching facts should return true
    lu.assertFalse(lr.watch('fats')) -- watching fats should return false

    lu.assertTrue(lu.assertPrints(function () return lr.assert({'foo'}) end, '==> { "foo" }'))
    f1 = {'bar', 'baz'}
    lu.assertTrue(lu.assertPrints(function () return lr.assert(f1) end, '==> { "bar", "baz" }'))
    lu.assertTrue(lu.assertPrints(function () return lr.retract(f1) end, '<== { "bar", "baz" }'))

    lu.assertTrue(lr.unwatch('facts'))
    -- test that unwatch('facts') turns off printing
    lu.assertTrue(lu.assertPrints(function () return lr.assert({'foo'}) end, nil))
end

function testLuaRulesDeffacts()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts'))
    lu.assertTrue(lr.clear())

    lu.assertTrue(lr.deffacts('start', {'foo'}))
    lu.assertTrue(lr.assert({'foo'}))
    lu.assertTrue(lr.watch('facts')) 
    -- watching facts should have reset trigger both retract of all existing
    -- facts and assert for all deffacts
    lu.assertTrue(lu.assertPrints(function () return lr.reset() end, '<== { "foo" }\n==> { "foo" }'))
end

function testLuaRulesDefrule()
    local lr = require('luarules')
    lu.assertTrue(lr.unwatch('facts'))
    lu.assertTrue(lr.clear())

    lu.assertTrue(lr.defrule('rule1', {'foo'}, function () print('bar') end))
    lu.assertTrue(lr.assert({'foo'}))
    -- this was wrong, issuing a run() would actually empty the agenda
    -- lu.assertTrue(lr.run())
    lu.assertEquals(#lr.agenda(), 1)
end

os.exit(lu.LuaUnit.run())