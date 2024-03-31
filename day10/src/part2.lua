require "grid"
require "path"
require "utils"
require "vec2"



local filename = arg[1]
local grid = Grid:parse(read_lines(filename))

local res = find_main_loop(grid)


if res == nil then
    print("No path found!")
else
    -- print_normals(grid, res)
    print("Answer: " .. res:get_area())
end
