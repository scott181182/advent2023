


--- @class Vec2
--- @field x number
--- @field y number
Vec2 = {}
Vec2.__index = Vec2






---@param x number
---@param y number
---@return Vec2
function Vec2:new(x, y)
    local vec = {}
    setmetatable(vec, Vec2)
    vec.x = x
    vec.y = y
    return vec
end

VECS = {
    Up        = Vec2:new( 0.0,  1.0),
    UpRight   = Vec2:new( 0.5,  0.5),
    Right     = Vec2:new( 1.0,  0.0),
    DownRight = Vec2:new( 0.5, -0.5),
    Down      = Vec2:new( 0.0, -1.0),
    DownLeft  = Vec2:new(-0.5, -0.5),
    Left      = Vec2:new(-1.0,  0.0),
    UpLeft    = Vec2:new(-0.5,  0.5)
}

---@return Vec2
function Vec2:inverse()
    if self == VECS.Up then return VECS.Down
    elseif self == VECS.UpRight then return VECS.DownLeft
    elseif self == VECS.Right then return VECS.Left
    elseif self == VECS.DownRight then return VECS.UpLeft
    elseif self == VECS.Down then return VECS.Up
    elseif self == VECS.DownLeft then return VECS.UpRight
    elseif self == VECS.Left then return VECS.Right
    elseif self == VECS.UpLeft then return VECS.DownRight
    ---@diagnostic disable-next-line: missing-return
    end
end

---@param condition boolean
---@return Vec2
function Vec2:inverse_if(condition)
    return condition and self:inverse() or self
end