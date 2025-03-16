
local HUD_SPRITESHEET = love.graphics.newImage("asset/image/hud_items.png")

local HUD_LIVES = love.graphics.newQuad(0, 0, 8, 8, HUD_SPRITESHEET)
local HUD_MISSILE = love.graphics.newQuad(8, 0, 8, 8, HUD_SPRITESHEET)

hud = {}

hud.draw = function(self)
    
end