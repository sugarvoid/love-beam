BaseEnemy = Object:extend()

local MOTHERSHIP_SPR = love.graphics.newImage("asset/image/mother_ship.png")


function BaseEnemy:new()
  self.position = Vec2:new(0,0)
  self.sprite = nil
  self.scale = 1
  self.moving_dir = {0,0}
  self.lane = nil
end

function BaseEnemy:draw()
  love.graphics.draw(self.sprite, self.position.x, self.position.y, 0, self.scale, self.scale)
end

function BaseEnemy:update()
  --logger.fatal("Enemy class does not have update function.")
  error("Enemy needs their own update function.")
end


Mothership = BaseEnemy:extend()


--love.graphics.line(227 / 2 - 20, 30, 227 / 2 - 40, 128)

function Mothership:new()
  Mothership.super.new(self)
  self.position.x = 30
  self.position.y = 20
  self.sprite = MOTHERSHIP_SPR
  self.scale = .7
  print(self.position)
end

function Mothership:update()
  logger.info("I have my own update()")
end

GreenShip = BaseEnemy:extend()
WhiteShip = BaseEnemy:extend()


function get_line_point(start_pos, end_pos, dist)
  local u = {end_pos.x - start_pos.x, end_pos.y - start_pos.y}
  local p = 0
end




