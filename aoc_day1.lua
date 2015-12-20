-- Advent of code 2015, Day 1 : Not Quite Lisp

---- #### Code #### ----

-- part 1
function findFloor( directions )
	floor = 0

	for c in directions:gmatch"." do
		if	c == '(' then
			floor = floor + 1
		elseif c == ')' then
			floor = floor - 1
		end
	end

	return floor
end

-- part 2
function basementCharacter ( directions )
	floor, i = 0, 1

	for c in directions:gmatch"." do
		if c == '(' then
			floor = floor + 1
		elseif c == ')' then
			floor = floor - 1
		end
		if floor == -1 then
			break
		else
			i = i + 1
		end
		
	end

	return i
end

---- #### Test #### ----

luaunit = require('luaunit')

function testFindFloorPositif()
	luaunit.assertEquals( findFloor("(())"), 0 )
	luaunit.assertEquals( findFloor("((("), 3 )
	luaunit.assertEquals( findFloor("))((((("), 3 )
end

function testFindFloorNegatif()
	luaunit.assertEquals( findFloor("))("), -1 )
	luaunit.assertEquals( findFloor(")())())"), -3 )
end

function testBasementCharacter()
	luaunit.assertEquals( basementCharacter(")"), 1 )
	luaunit.assertEquals( basementCharacter("()())"), 5 )
end

os.exit( luaunit.LuaUnit.run() )
-- print( findFloor('') )
-- print( basementCharacter('') )
