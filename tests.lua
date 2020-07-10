-- Lua Rules : A forward chaining rete rules engine

local lu = require('luaunit')

function testHookup()
    lu.assertEquals(1, 1)
end

function testLuaRulesModule()
    lu.assertIsTable(require('luarules'))
end

os.exit(lu.LuaUnit.run())