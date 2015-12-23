-- Advent of code 2015, Day 5 : Doesn't He Have Intern-Elves For This?

---- #### Code #### ----

-- part 1
function niceString( s )
	local vowelsCount = 0
	local prevLetter = ' '
	local asDoubleLetter = false

	for c in s:gmatch"." do
		if string.find("aeiou", c) ~= nil then vowelsCount = vowelsCount + 1 end
		if prevLetter == c then asDoubleLetter = true end
		prevLetter = c
	end

	local asNotSomeString = ( 
		string.find(s, "ab") == nil
		and string.find(s, "cd") == nil
		and string.find(s, "pq") == nil
		and string.find(s, "xy") == nil
	)

	return ( vowelsCount >= 3 and asDoubleLetter and asNotSomeString )

end

function countNiceString( list )
	local niceStringCount = 0

	for i,v in ipairs(list) do
		if niceString(v) == true then
			niceStringCount = niceStringCount + 1
		end
	end

	return niceStringCount
end

-- part 2
function niceStringV2( s )
	return nil
end

---- #### Test #### ----

luaunit = require('luaunit')

function testNiceString()
	luaunit.assertEquals( niceString("ugknbfddgicrmopn"), true )
	luaunit.assertEquals( niceString("aaa"), true )
	luaunit.assertEquals( niceString("jchzalrnumimnmhp"), false )
	luaunit.assertEquals( niceString("haegwjzuvuyypxyu"), false )
	luaunit.assertEquals( niceString("dvszwmarrgswjxmb"), false )
end

function testCountNiceString()
	local strings = {
		"ugknbfddgicrmopn",
		"aaa",
		"jchzalrnumimnmhp"
	}
	luaunit.assertEquals( countNiceString(strings), 2 )
end

function testNiceStringV2( ... )
	luaunit.assertEquals( niceStringV2("qjhvhtzxzqqjkmpb"), true )
	luaunit.assertEquals( niceStringV2("xxyxx"), true )
	luaunit.assertEquals( niceStringV2("uurcxstgmygtbstg"), false )
	luaunit.assertEquals( niceStringV2("ieodomkazucvgmuy"), false )
end

os.exit( luaunit.LuaUnit.run() )
