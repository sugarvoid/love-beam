Bullet = Object:extend()

local BULLET_SPRITESHEET = love.graphics.newImage("asset/image/bullet_sheet.png")

local BULLET_ORANGE = love.graphics.newQuad(0, 0, 8, 8, BULLET_SPRITESHEET)
local BULLET_RED = love.graphics.newQuad(8, 0, 8, 8, BULLET_SPRITESHEET)

function Bullet:new(x, y)
  self.x = x
  self.y = y
  self.scale = 1
  self.speed = 1
  self.sprite = BULLET_ORANGE
  self.direction = -1
  self.target = { x = self.x + 4, y = 30 }
  self.dx = self.target.x - self.x
  self.dy = self.target.y - self.y
  local len = math.sqrt(self.dx ^ 2 + self.dy ^ 2)
  self.dx = self.dx / len
  self.dy = self.dy / len
  return self
end

function Bullet:update()
  self.x = self.x + self.dx * self.speed --* dt
  self.y = self.y + self.dy * self.speed --* dt
  self.scale = self.scale - 0.009
  if self.y <= 28 then
    table.remove_item(bullets, self)
  end
end

function Bullet:draw()
  love.graphics.draw(BULLET_SPRITESHEET, self.sprite, self.x, self.y, 0, self.scale, self.scale, 4, 1)
end
