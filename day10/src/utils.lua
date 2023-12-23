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
    for i, c in ipairs(path) do
        print_coord(c)
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
