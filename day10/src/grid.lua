

--- @class Grid
--- @field height integer
--- @field width integer
--- @field lines string[]
Grid = {}
Grid.__index = Grid

---@param lines string[]
---@return Grid
function Grid:parse(lines)
    local grid = {}
    setmetatable(grid, Grid)
    grid.lines = lines
    grid.height = #lines
    grid.width = lines[1]:len()
    return grid
end

---@param width integer
---@param height integer
---@return Grid
function Grid:blank(width, height)
    local grid = {}
    setmetatable(grid, Grid)
    grid.width = width
    grid.height = height

    local lines = {}
    for _=1,height do
        table.insert(lines, string.rep(".", width))
    end
    grid.lines = lines
    return grid
end

--- @return Coord[][]
function Grid:normals()
    local start = self:find_start_location()
end

---@param x integer
---@param y integer
---@return string
function Grid:get_character(x, y)
    return self.lines[y]:sub(x,x)
end

--- @return Coord
function Grid:find_start_location()
    for row, line in ipairs(self.lines) do
        for col = 1, #line do
            local c = line:sub(col, col)
            if c == 'S' then
                return { x = col, y = row }
            end
        end
    --- @diagnostic disable-next-line: missing-return
    end
end