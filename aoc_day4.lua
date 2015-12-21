-- Advent of code 2015, Day 4 : The Ideal Stocking Stuffer

---- #### Code #### ----
local md5 = require 'md5'

function findHashEnd( key )
	local i = 1

	while string.sub( md5.sumhexa(key .. i), 1, 6) ~= "000000" do
		i = i + 1
	end

	return i
end

---- #### Test #### ----

luaunit = require('luaunit')

function testFindHashEnd()
	luaunit.assertEquals( findHashEnd("abcdef"), 609043 )
	-- SLOWWWWWWWWWWWWWWWWWWWWWWWw
	-- luaunit.assertEquals( findHashEnd("pqrstuv"), 1048970 )
end

os.exit( luaunit.LuaUnit.run() )

