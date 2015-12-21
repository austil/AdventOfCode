-- Advent of code 2015, Day 3 : Perfectly Spherical Houses in a Vacuum

---- #### Code #### ----

-- part 1
function houseVisited( roadMap )
	local visitedHouses = {}
	local visitedHousesCount = 0
	local x, y = 0, 0

	visitedHouses[x] = {}
	visitedHouses[x][y] = true
	visitedHousesCount = visitedHousesCount + 1

	for c in roadMap:gmatch"." do
		if c == '^' then y = y + 1
		elseif c == '>' then x = x + 1
		elseif c == 'v' then y = y - 1
		elseif c == '<' then x = x - 1
		end

		if visitedHouses[x] == nil then visitedHouses[x] = {} end
		if visitedHouses[x][y] == nil then 
			visitedHousesCount = visitedHousesCount + 1 
			visitedHouses[x][y] = true 
		end
	end

	return visitedHousesCount
end

-- part 2
function houseVisitedV2( roadMap )
	local visitedHouses, visitedHousesCount = {}, 0
	local xSanta, ySanta = 0, 0
	local xRobot, yRobot = 0, 0
	local santaTurn = true

	visitedHouses[xSanta] = {}
	visitedHouses[xSanta][ySanta] = true
	visitedHousesCount = visitedHousesCount + 1

	for c in roadMap:gmatch"." do
		-- choosing character coordinate
		if santaTurn == true then
			x, y = xSanta, ySanta
		else
			x, y = xRobot, yRobot
		end

		-- modify coordinate
		if c == '^' then y = y + 1
		elseif c == '>' then x = x + 1
		elseif c == 'v' then y = y - 1
		elseif c == '<' then x = x - 1
		end

		-- mark the house
		if visitedHouses[x] == nil then visitedHouses[x] = {} end
		if visitedHouses[x][y] == nil then 
			visitedHousesCount = visitedHousesCount + 1 
			visitedHouses[x][y] = true 
		end

		-- saving character coordinate
		if santaTurn == true then
			xSanta, ySanta = x, y
		else
			xRobot, yRobot = x, y
		end
		-- changing character
		santaTurn = not santaTurn
	end

	return visitedHousesCount
end

---- #### Test #### ----

luaunit = require('luaunit')

function testHouseVisited()
	luaunit.assertEquals( houseVisited(">"), 2 )
	luaunit.assertEquals( houseVisited("^>v<"), 4 )
	luaunit.assertEquals( houseVisited("^v^v^v^v^v"), 2 )
end

function testHouseVisitedV2()
	luaunit.assertEquals( houseVisitedV2("^v"), 3 )
	luaunit.assertEquals( houseVisitedV2("^>v<"), 3 )
	luaunit.assertEquals( houseVisitedV2("^v^v^v^v^v"), 11 )
end

os.exit( luaunit.LuaUnit.run() )
