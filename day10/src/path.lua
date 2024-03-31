


Direction = {
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3
}

NextDirectionMap = {
    [Direction.UP] = {
        ["|"] = Direction.UP,
        ["7"] = Direction.LEFT,
        ["F"] = Direction.RIGHT,
    },
    [Direction.DOWN] = {
        ["|"] = Direction.DOWN,
        ["J"] = Direction.LEFT,
        ["L"] = Direction.RIGHT,
    },
    [Direction.LEFT] = {
        ["-"] = Direction.LEFT,
        ["F"] = Direction.DOWN,
        ["L"] = Direction.UP,
    },
    [Direction.RIGHT] = {
        ["-"] = Direction.RIGHT,
        ["J"] = Direction.UP,
        ["7"] = Direction.DOWN,
    }
}
StartSymbolMap = {
    [Direction.UP] = {
        [Direction.UP] = "|",
        [Direction.LEFT] = "7",
        [Direction.RIGHT] = "F",
    },
    [Direction.DOWN] = {
        [Direction.DOWN] = "|",
        [Direction.LEFT] = "J",
        [Direction.RIGHT] = "L",
    },
    [Direction.LEFT] = {
        [Direction.DOWN] = "7",
        [Direction.LEFT] = "-",
        [Direction.UP] = "J",
    },
    [Direction.RIGHT] = {
        [Direction.DOWN] = "F",
        [Direction.RIGHT] = "-",
        [Direction.UP] = "L",
    }
}

--- @param from Coord
--- @param to Coord
--- @return integer
function get_direction(from, to)
    if from.x == to.x - 1 then
        return Direction.RIGHT
    elseif from.x == to.x + 1 then
        return Direction.LEFT
    elseif from.y == to.y - 1 then
        return Direction.DOWN
    elseif from.y == to.y + 1 then
        return Direction.UP
    ---@diagnostic disable-next-line: missing-return
    end
end



--- @alias PathSegment { coord: Coord, normal: Vec2 }

--- @class Path
--- @field start Coord
--- @field width integer
--- @field height integer
--- @field segments PathSegment[]
Path = {}
Path.__index = Path

---@param start Coord
---@param segments PathSegment[]
---@return Path
function Path:new(start, segments)
    local path = {}
    setmetatable(path, Path)
    path.start = start
    path.segments = segments

    local width, height = get_path_bounds(segments)
    path.width = width
    path.height = height

    return path
end

---@param segs PathSegment[]
---@return integer, integer
function get_path_bounds(segs)
    local c1 = segs[1].coord
    local min_x = c1.x
    local max_x = c1.x
    local min_y = c1.y
    local max_y = c1.y

    for _, seg in ipairs(segs) do
        if seg.coord.x < min_x then
            min_x = seg.coord.x
        elseif seg.coord.x > max_x then
            max_x = seg.coord.x
        end

        if seg.coord.y < min_y then
            min_y = seg.coord.y
        elseif seg.coord.y > max_y then
            max_y = seg.coord.y
        end
    end

    return max_x - min_x + 1, max_y - min_y + 1
end

---@return integer
function Path:length()
    return #self.segments
end
---@param x integer
---@param y integer
---@return PathSegment | nil
function Path:get_segment(x, y)
    for _, seg in ipairs(self.segments) do
        if seg.coord.x == x and seg.coord.y == y then
            return seg
        end
    end

    return nil
end

---@return integer
function Path:get_area()
    local total = 0

    for y=1,self.height do
        local running_norm = 0
        for x=1,self.width do
            local maybe_seg = self:get_segment(x, y)
            if maybe_seg ~= nil then
                running_norm = running_norm + maybe_seg.normal.x
            end

            if running_norm <= -1 and maybe_seg == nil then
                total = total + 1
            end
        end
    end

    return total
end



--- @param grid Grid
--- @param path Coord[]
--- @param coord Coord
--- @param direction integer The direction of the incoming path (UP means it's coming _from_ the bottom).
--- @return Coord[] | nil
function explore_path(grid, path, coord, direction)
    -- print_coord(coord)
    if coord.x < 1 or coord.x > grid.width or coord.y < 1 or coord.y > grid.height then
        return nil
    end

    local next_sym = grid:get_character(coord.x, coord.y)
    -- print("    " .. next_sym)

    -- Short-circuit for finishing the path
    if next_sym == "S" then
        table.insert(path, coord)
        return path
    end

    --- @type integer | nil
    local next_direction = NextDirectionMap[direction][next_sym]
    if next_direction == nil then return nil end

    local next_coord = { x = coord.x, y = coord.y }
    if next_direction == Direction.UP then
        next_coord.y = next_coord.y - 1
    elseif next_direction == Direction.DOWN then
        next_coord.y = next_coord.y + 1
    elseif next_direction == Direction.LEFT then
        next_coord.x = next_coord.x - 1
    elseif next_direction == Direction.RIGHT then
        next_coord.x = next_coord.x + 1
    end

    table.insert(path, coord)
    return explore_path(grid, path, next_coord, next_direction)
end



---@param grid Grid
---@param coords Coord[]
---@return integer, PathSegment
function find_leftmost_segment(grid, coords)
    -- Skip the starting coord, since that's the "S" character
    local left_coord = coords[2]
    local left_idx = 2

    for i, c in ipairs(coords) do
        if c.x < left_coord.x then
            left_coord = c
            left_idx = i
        end
    end

    local sym = grid:get_character(left_coord.x, left_coord.y)
    ---@type Vec2 | nil
    local normal = nil

    if sym == "|" then
        normal = VECS.Down
    elseif sym == "F" then
        normal = VECS.UpLeft
    elseif sym == "L" then
        normal = VECS.DownLeft
    end

    return left_idx, { coord = left_coord, normal = normal }
end



---@param coords Coord[]
---@return string
function infer_start_symbol(coords)
    local dir_in = get_direction(coords[#coords - 1], coords[1])
    local dir_out = get_direction(coords[1], coords[2])

    return StartSymbolMap[dir_in][dir_out]
end

---@param sym string
---@param dir integer
---@param last_normal Vec2
---@return Vec2
function get_normal(sym, dir, last_normal)
    if sym == "|" then
        return VECS.Right:inverse_if(last_normal.x < 0)
    elseif sym == "-" then
        return VECS.Up:inverse_if(last_normal.y < 0)
    elseif sym == "F" then
        if dir == Direction.UP then
            return VECS.DownRight:inverse_if(last_normal.x < 0)
        else
            return VECS.UpLeft:inverse_if(last_normal.y < 0)
        end
    elseif sym == "L" then
        if dir == Direction.DOWN then
            return VECS.UpRight:inverse_if(last_normal.x < 0)
        else
            return VECS.UpRight:inverse_if(last_normal.y < 0)
        end
    elseif sym == "7" then
        if dir == Direction.UP then
            return VECS.UpRight:inverse_if(last_normal.x < 0)
        else
            return VECS.UpRight:inverse_if(last_normal.y < 0)
        end
    elseif sym == "J" then
        if dir == Direction.DOWN then
            return VECS.DownRight:inverse_if(last_normal.x < 0)
        else
            return VECS.UpLeft:inverse_if(last_normal.y < 0)
        end
        ---@diagnostic disable-next-line: missing-return
    end
end

---@param grid Grid
---@param coords Coord[]
---@param idx integer
---@param segments PathSegment[]
---@return PathSegment[]
function calculate_normals_forward(grid, coords, idx, segments)
    if idx > #coords then return segments end

    local next_coord = coords[idx]
    local sym = grid:get_character(next_coord.x, next_coord.y)
    local last_coord = segments[#segments].coord
    local last_normal = segments[#segments].normal
    local dir = get_direction(last_coord, next_coord)

    if sym == "S" then
        sym = infer_start_symbol(coords)
    end

    local normal = get_normal(sym, dir, last_normal)

    table.insert(segments, { coord = next_coord, normal = normal })
    return calculate_normals_forward(grid, coords, idx + 1, segments)
end
---@param grid Grid
---@param coords Coord[]
---@param idx integer
---@param segments PathSegment[]
---@return PathSegment[]
function calculate_normals_backward(grid, coords, idx, segments)
    if idx < 1 then return segments end

    local next_coord = coords[idx]
    local sym = grid:get_character(next_coord.x, next_coord.y)
    local last_coord = segments[1].coord
    local last_normal = segments[1].normal
    local dir = get_direction(last_coord, next_coord)

    if sym == "S" then
        -- TODO: determine the "actual" symbol.
        sym = infer_start_symbol(coords)
    end

    local normal = get_normal(sym, dir, last_normal)

    table.insert(segments, 1, { coord = next_coord, normal = normal })
    return calculate_normals_backward(grid, coords, idx - 1, segments)
end

---@param grid Grid
---@param coords Coord[]
---@return PathSegment[]
function calculate_normals(grid, coords)
    local first_idx, first_seg = find_leftmost_segment(grid, coords)

    ---@type PathSegment[]
    local segments = { first_seg }
    calculate_normals_forward(grid, coords, first_idx + 1, segments)
    calculate_normals_backward(grid, coords, first_idx - 1, segments)

    -- for _, c in ipairs(coords) do
    --     segments[#segments+1] = { coord = c, normal = { x = 0.0, y = 0.0 } }
    -- end



    return segments
end



--- @param grid Grid
--- @return Path | nil
function find_main_loop(grid)
    local start = grid:find_start_location()

    local path = { start }
    -- Try Up
    local res = explore_path(grid, path, { x=start.x, y=start.y - 1 }, Direction.UP)

    if res == nil then
        -- Try Down
        path = { start }
        res = explore_path(grid, path, { x=start.x, y=start.y + 1 }, Direction.DOWN)
    end
    if res == nil then
        -- Try Left
        path = { start }
        res = explore_path(grid, path, { x=start.x - 1, y=start.y }, Direction.LEFT)
    end
    -- No need to try Right, since we would've found it already.

    if res == nil then return nil end

    local segments = calculate_normals(grid, res)

    return Path:new(start, segments)
end