require "grid"
require "path"
require "utils"



local filename = arg[1]
local grid = Grid:parse(read_lines(filename))

local res = find_main_loop(grid)
if res == nil then
    print("No path found!")
else
    -- print_path(res.path)
    local answer = math.floor(#res.path / 2)
    print("Answer: " .. answer)
end
