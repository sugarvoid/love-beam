local SFX_FIRE = love.audio.newSource("asset/sound/player_fire.wav", "static")
local PLAYER_IMG = love.graphics.newImage("asset/image/player.png")

Player = Object:extend()

function Player:new()
    self.lane = 3 -- for bullet path
    self.x = LANES[self.lane]
    self.y = 100
    self.lives = 3
    self.missiles = 3
    self.next_x = nil
    self.is_moving = false
end

function Player:move(dir)
    if dir == "left" then
        self.x = self.x - 1
    elseif dir == "right" then
        self.x = self.x + 1
    end
end

function Player:update()
    print(self.x)
end

function Player:on_hit(baddie)
    self.lives = self.lives - 1
end

function Player:draw()
    love.graphics.draw(PLAYER_IMG, self.x, self.y)
end

function Player:reset()
    self.lives = 3
    self.missiles = 3
end

function Player:shoot_bullet()
    local b = Bullet(self.x + 8, self.y)
    local _sfx = SFX_FIRE:clone()
    _sfx:play()
    table.insert(bullets, b)
end
