-- Advent of code 2015, Day 2: I Was Told There Would Be No Math

---- #### Code #### ----

-- part 1
function calcWrapping( l, w, h )
	local sides = { l*w, w*h, h*l }
	local smallestSide = sides[1]
	local requiredPaper = 0

	for k,v in ipairs(sides) do
		requiredPaper = requiredPaper + (2 * v)
		if v < smallestSide then smallestSide = v end
	end

	return requiredPaper + smallestSide
end

function calcWrappingList( presentlist )
	local requiredPaper = 0
	for i,v in ipairs(presentlist) do
		requiredPaper = requiredPaper + calcWrapping(v[1], v[2], v[3])
	end
	return requiredPaper
end

-- part 2
function calcRibbon( l, w, h )
	local sides = { 2*(l+w), 2*(w+h), 2*(h+l) }
	local bow = l*w*h
	table.sort( sides )
	return sides[1] + bow
end

function calcRibbonList( presentlist )
	local requiredRibbon = 0
	for i,v in ipairs(presentlist) do
		requiredRibbon = requiredRibbon + calcRibbon(v[1], v[2], v[3])
	end
	return requiredRibbon
end

---- #### Test #### ----

luaunit = require('luaunit')

function testCalcWrapping()
	luaunit.assertEquals( calcWrapping(2,3,4) , 58 )
	luaunit.assertEquals( calcWrapping(1,1,10) , 43 )
end

function testCalcWrappingList()
	local presentSizeList = {
		{2,3,4},
		{1,1,10}
	}
	luaunit.assertEquals( calcWrappingList(presentSizeList), 101 )
end

function testCalcRibbon()
	luaunit.assertEquals( calcRibbon(2,3,4) , 34 )
	luaunit.assertEquals( calcRibbon(1,1,10) , 14 )
end

function testCalcRibbonList()
	local presentSizeList = {
		{2,3,4},
		{1,1,10}
	}
	luaunit.assertEquals( calcRibbonList( presentSizeList ), 48 )
end

os.exit( luaunit.LuaUnit.run() )
