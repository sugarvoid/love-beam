Bullet = Object:extend()

local BULLET_SPRITESHEET = love.graphics.newImage("asset/image/bullet_sheet.png")

local BULLET_ORANGE = love.graphics.newQuad(0, 0, 8, 8, BULLET_SPRITESHEET)
local BULLET_RED = love.graphics.newQuad(8, 0, 8, 8, BULLET_SPRITESHEET)

function Bullet:new()
  self.x = 60
  self.y = 60
  self.sprite = BULLET_ORANGE
  self.direction = -1
  return self
end

function Bullet:update()
    
end

function Bullet:draw()
    love.graphics.draw(BULLET_SPRITESHEET, self.sprite, self.x, self.y, 0, 1, 1, 4, 1)
end