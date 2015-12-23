-- Advent of code 2015, Day 6 : Probably a Fire Hazard

---- #### Code #### ----

-- part 1
function initGrid( )
	local newGrid = {}
	for x = 0, 999 do
		newGrid[x] = {}
		for y = 0, 999 do
			newGrid[x][y] = false
		end
	end

	return newGrid
end

function modifyGrid( grid, operation, x1, y1, x2, y2 )
	for x = x1, x2 do
		for y = y1, y2 do
			grid[x][y] = operation( grid[x][y] )
		end
	end
end

turn_off = function ( ... ) return false end

turn_on = function ( ... ) return true end

toggle = function ( light ) return not light end

function countLightOn( grid )
	local count = 0
	for kx,x in pairs(grid) do
		for ky,y in pairs(x) do
			if y == true then count = count + 1 end
		end
	end

	return count
end

---- #### Test #### ----

luaunit = require('luaunit')

function testInitGrid()
	local grid = initGrid()
	luaunit.assertEquals( #grid, 999 )
	luaunit.assertEquals( grid[0][0], false )
	luaunit.assertEquals( grid[0][999], false )
	luaunit.assertEquals( grid[999][0], false )
	luaunit.assertEquals( grid[999][999], false )
end

function testOperation()
	luaunit.assertEquals( turn_off(), false )
	luaunit.assertEquals( turn_on(), true)
	luaunit.assertEquals( toggle(true), false )
	luaunit.assertEquals( toggle(false), true )
end

function testModifyGrid()
	local grid = initGrid()
	modifyGrid( grid, turn_on, 0, 0, 999, 999 )
	luaunit.assertEquals( grid[0][0], true )
	luaunit.assertEquals( grid[999][999], true )

	modifyGrid( grid, toggle, 0, 0, 999, 0 )
	luaunit.assertEquals( grid[0][0], false )
	luaunit.assertEquals( grid[999][0], false )
	luaunit.assertEquals( grid[0][1], true )
	luaunit.assertEquals( grid[999][999], true )
end

function testCountLightOn()
	local grid = initGrid()
	luaunit.assertEquals( countLightOn(grid), 0 )
	modifyGrid( grid, toggle, 0, 0, 999, 0 )
	luaunit.assertEquals( countLightOn(grid), 1000 )
end

os.exit( luaunit.LuaUnit.run() )
