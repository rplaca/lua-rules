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
    lu.assertEquals(#lr.fact_list, 1)
    
end

os.exit(lu.LuaUnit.run())