-- Advent of code 2015, Day 7 : Some Assembly Required

---- #### Code #### ----

-- part 1
function newCircuit()
	return {}
end

function addInstruction( circuit, instruction )
	local op = instruction:split("->")
	local source, destination = op[1], op[2]:gsub("%s+", "")

	if string.find(source, "AND") then
		source = source:split(" AND ")
		source = bit32.band( 
				circuit[source[1]:gsub("%s+", "")], 
				circuit[source[2]:gsub("%s+", "")] 
			)

	elseif string.find(source, "OR") then
		source = source:split(" OR ")
		source = bit32.bor( 
				circuit[source[1]:gsub("%s+", "")], 
				circuit[source[2]:gsub("%s+", "")] 
			)

	elseif string.find(source, "NOT") then
		source = source:gsub("NOT ", "")
		source = bit32.bnot( circuit[source:gsub("%s+", "")] )

	elseif string.find(source, "LSHIFT") then
		source = source:split("LSHIFT")
		source = bit32.lshift( 
				circuit[source[1]:gsub("%s+", "")], 
				source[2]:gsub("%s+", "") 
			)

	elseif string.find(source, "RSHIFT") then
		source = source:split(" RSHIFT ")
		source = bit32.rshift( 
				circuit[source[1]:gsub("%s+", "")], 
				source[2]:gsub("%s+", "") 
			)

	else
		source = source:gsub("%s+", "")
	end

	circuit[destination] = source

end

-- http://lua-users.org/wiki/SplitJoin
function string:split(sep)
    local sep, fields = sep or ":", {}
    local pattern = string.format("([^%s]+)", sep)
    self:gsub(pattern, function(c) fields[#fields+1] = c end)
    return fields
end

---- #### Test #### ----

luaunit = require('luaunit')

function testNewCircuit()
	luaunit.assertEquals( newCircuit(), {})
end

function testAddInstruction()
	local circuitTest = newCircuit()
	addInstruction( circuitTest, "123 -> x" )
	addInstruction( circuitTest, "456 -> y" )
	addInstruction( circuitTest, " x AND y -> d")
	addInstruction( circuitTest, " x OR y -> e")
	addInstruction( circuitTest, " x LSHIFT 2 -> f")
	addInstruction( circuitTest, " y RSHIFT 2 -> g")
	addInstruction( circuitTest, " NOT x -> h")
	addInstruction( circuitTest, " NOT y -> i")

	luaunit.assertEquals( circuitTest['x'], "123" )
	luaunit.assertEquals( circuitTest['y'], "456" )
	luaunit.assertEquals( circuitTest['d'], 72 )
	luaunit.assertEquals( circuitTest['e'], 507 )
	luaunit.assertEquals( circuitTest['f'], 492 )
	luaunit.assertEquals( circuitTest['g'], 114 )
	luaunit.assertEquals( circuitTest['h'], 65412)
	luaunit.assertEquals( circuitTest['i'], 65079)
	luaunit.assertEquals( circuitTest['x'], 123)
	luaunit.assertEquals( circuitTest['y'], 456)
end

os.exit( luaunit.LuaUnit.run() )

