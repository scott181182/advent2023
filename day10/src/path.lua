


Direction = {
    UP = 0,
    DOWN = 1,
    LEFT = 2,
    RIGHT = 3
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
    end
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
    local next_direction = nil

    if direction == Direction.UP then
        if next_sym == "|" then
            next_direction = Direction.UP
        elseif next_sym == "7" then 
            next_direction = Direction.LEFT
        elseif next_sym == "F" then
            next_direction = Direction.RIGHT
        end
    elseif direction == Direction.DOWN then
        if next_sym == "|" then
            next_direction = Direction.DOWN
        elseif next_sym == "J" then 
            next_direction = Direction.LEFT
        elseif next_sym == "L" then
            next_direction = Direction.RIGHT
        end
    elseif direction == Direction.LEFT then
        if next_sym == "-" then
            next_direction = Direction.LEFT
        elseif next_sym == "F" then 
            next_direction = Direction.DOWN
        elseif next_sym == "L" then
            next_direction = Direction.UP
        end
    elseif direction == Direction.RIGHT then
        if next_sym == "-" then
            next_direction = Direction.RIGHT
        elseif next_sym == "J" then 
            next_direction = Direction.UP
        elseif next_sym == "7" then
            next_direction = Direction.DOWN
        end
    end

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

--- @param grid Grid
--- @return { start: Coord, path: Coord[] } | nil
function find_main_loop(grid)
    local start = grid:find_start_location()

    local path = { start }
    -- Try Up
    local res = explore_path(grid, path, { x=start.x, y=start.y - 1 }, Direction.UP)

    if res == nil then
        -- Try Down
        path = { start}
        res = explore_path(grid, path, { x=start.x, y=start.y + 1 }, Direction.DOWN)
    end
    if res == nil then
        -- Try Left
        path = { start }
        res = explore_path(grid, path, { x=start.x - 1, y=start.y }, Direction.LEFT)
    end
    -- No need to try Right, since we would've found it already.

    if res == nil then return nil end

    return { start = start, path = path }
end