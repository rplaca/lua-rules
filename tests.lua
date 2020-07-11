-- Lua Rules : A forward chaining rete rules engine

local lu = require('luaunit')

function testHookup()
    lu.assertEquals(1, 1)
end

function testLuaRulesModule()
    lu.assertIsTable(require('luarules'))
end

function testLuaRulesFactList()
    local lr = require('luarules')

    lu.assertEquals(#lr.fact_list, 0) -- ensure the fact-list is empty
    lu.assertTrue(lr.assert({})) -- asserting an empty table should return True
    lu.assertEquals(#lr.fact_list, 1) -- and the fact_list should have 1 fact

    lu.assertTrue(lr.retract({})) -- retracting the fact should return True
    lu.assertEquals(#lr.fact_list, 0) -- and the fact_list should be empty again
    
    lu.assertTrue(lr.assert({}, {}, {})) -- asserting three facts should work
    lu.assertEquals(#lr.fact_list, 3) -- and the fact_list should be three items long
end

os.exit(lu.LuaUnit.run())