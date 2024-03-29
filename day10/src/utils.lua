--- @alias Coord { x: integer, y: integer }

--- @param coord Coord
function stringify_coord(coord)
    return "(" .. coord.x .. ", " .. coord.y .. ")"
end
--- @param coord Coord
function print_coord(coord)
    print("(" .. coord.x .. ", " .. coord.y .. ")")
end
--- @param path Coord[]
function print_path(path)
    for _, c in ipairs(path) do
        print_coord(c)
    end
end


---@param grid Grid
---@param path Path
function print_normals(grid, path) 
    for y=1,grid.height do
        for x=1,grid.width do
            local maybe_seg = path:get_segment(x, y)
            if maybe_seg == nil then
                io.write(".")
            else
                io.write("X")
            end
        end
        print("")
    end
end



---@param filename string
---@return string[]
function read_lines(filename)
    local lines = {}
    for line in io.lines(filename) do
        lines[#lines + 1] = line
    end
    return lines
end



---@param num number
---@return number
function sgn(num)
    if num < 0 then
        return -1.0
    else
        return 1.0
    end
end