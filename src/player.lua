player = {
    x = 40,
    y = 110,
    lives = 3,
    lane = 0, -- for bullet path
    img = love.graphics.newImage("asset/image/player.png")
}

player.move =function(self, dir)
   if dir == "left" then
    self.x = self.x - 1
    elseif dir == "right" then
        self.x = self.x + 1
   end 
end

player.update = function(self)
    
end

player.on_hit = function(self, baddie)
    self.lives = self.lives - 1
end

player.draw = function(self)
    love.graphics.draw(self.img, self.x, self.y)
end

player.reset = function(self)
    self.lives = 3
end

player.shoot_bullet = function (self)
    local b = Bullet(self.x+8, self.y)
    table.insert(bullets, b)
end
