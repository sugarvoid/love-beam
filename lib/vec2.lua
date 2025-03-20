Vec2 = {}
Vec2.__index = Vec2


function Vec2:new(x, y)
    local _vec2 = setmetatable({}, Vec2)
    _vec2.x = x or 0
    _vec2.y = y or 0
    return _vec2
end

function Vec2:clone()
	return Vec2:new(self.x, self.y)
end


function Vec2:length_squared()
	return self.x * self.x + self.y * self.y
end

function Vec2:length()
	return math.sqrt(self:length_squared())
end

function Vec2:normalizeInplace()
	local l = self:length()
	if l > 0 then
		self.x, self.y = self.x / l, self.y / l
	end
	return self
end

function Vec2:normalized()
	return self:clone():normalizeInplace()
end


function Vec2:__tostring()
	return ("(%.2f, %.2f)"):format(self.x, self.y)
end