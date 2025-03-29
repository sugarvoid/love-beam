
is_debug_on = false

love.graphics.setDefaultFilter("nearest", "nearest")

if is_debug_on then
    love.profiler = require('lib.profile')
end


Object = require "lib.classic"
logger = require("lib.log")
baton = require("lib.baton")
lume = require("lib.lume")
flux = require("lib.flux")
anim8 = require("lib.anim8")

require("lib.vec2")
require("src.player")
require("src.bad_ship")
require("src.bullet")
require("src.hud")

local lines = {}
bullets = {}



table.insert(lines, { y = 35, s = 0.5 })
table.insert(lines, { y = 25, s = 0.5 })
table.insert(lines, { y = 15, s = 0.5 })
table.insert(lines, { y = 5, s = 0.5 })
table.insert(lines, { y = -5, s = 0.5 })
table.insert(lines, { y = -15, s = 0.5 })
table.insert(lines, { y = -25, s = 0.5 })


input = baton.new {
    controls = {
        left = { 'key:left', 'key:a', 'axis:leftx-', 'button:dpleft' },
        right = { 'key:right', 'key:d', 'axis:leftx+', 'button:dpright' },
        up = { 'key:up', 'key:w', 'axis:lefty-', 'button:dpup' },
        down = { 'key:down', 'key:s', 'axis:lefty+', 'button:dpdown' },
        fire = { 'key:x', 'button:a', 'key:space' },
        missile = { 'key:z', 'button:b', 'key:lshift' },
        quit = { 'key:q', 'button:back', 'key:escape' },
        pause = { 'key:return', 'button:start' } },
    pairs = {
        move = { 'left', 'right', 'up', 'down' } },
    joystick = love.joystick.getJoysticks()[1],
}

local pause_img = love.graphics.newImage("asset/image/pause.png")

require("src.functions")
require("lib.timer")

local screen_rect = { x = 0, y = 0, w = 227, h = 128 }

--[[ 
TODO: Fix these, they were gotten using player sprite, 
        but forgot to account for player offset. 
]]--
LANES = {30,70,105,142,180}

LANES_POS = {
    {top=nil, bottom=nil},
    {top=nil, bottom=nil},
    {top=nil, bottom=nil},
    {top=nil, bottom=nil},
    {top=nil, bottom=nil},
    {top=nil, bottom=nil},
    {top=nil, bottom=nil}
}

LANES_POS = {
    {{x = 8, y = 30}, {x = -67, y = 128}},
    {{x = 38, y = 30}, {x = -17, y = 128}},
    {{x = 68, y = 30}, {x = 33, y = 128}},
    {{x = 93, y = 30}, {x = 73, y = 128}},
    {{x = 113, y = 30}, {x = 113, y = 128}},
    {{x = 133, y = 30}, {x = 153, y = 128}},
    {{x = 158, y = 30}, {x = 193, y = 128}},
    {{x = 188, y = 30}, {x = 243, y = 128}},
    {{x = 218, y = 30}, {x = 313.5, y = 128}},
}



-- love.graphics.line(226 / 2 - 105, 30, 226 / 2 - 180, 128)
-- love.graphics.line(226 / 2 - 75, 30, 226 / 2 - 130, 128)
-- love.graphics.line(226 / 2 - 45, 30, 226 / 2 - 80, 128)
-- love.graphics.line(226 / 2 - 20, 30, 226 / 2 - 40, 128)
-- love.graphics.line(226 / 2, 30, 226 / 2, 128)
-- love.graphics.line(226 / 2 + 20, 30, 226 / 2 + 40, 128)
-- love.graphics.line(226 / 2 + 45, 30, 226 / 2 + 80, 128)
-- love.graphics.line(226 / 2 + 75, 30, 226 / 2 + 130, 128)
-- love.graphics.line(226 / 2 + 105, 30, 267 / 2 + 180, 128)



function love.load()
    player = Player()
    if is_debug_on then
        logger.level = logger.Level.DEBUG
        logger.debug("Entering debug mode")
        love.profiler.start()
    else
        logger.level = logger.Level.INFO
        logger.info("logger in INFO mode")
    end
    math.randomseed(os.time())
    font = love.graphics.newFont("asset/font/mago2.ttf", 32)
    font:setFilter("nearest")
    love.graphics.setFont(font)

    -- if your code was optimized for fullHD:
    window = { translateX = 0, translateY = 0, scale = 4, width = 227, height = 128 }
    width, height = love.graphics.getDimensions()
    love.window.setMode(width, height, { resizable = true, borderless = false })
    resize(width, height) -- update new translation and scale


    TEST_MS = Mothership()

    TEST_GS = MovingShip("white")

    table.insert(all_ships, TEST_MS)
    table.insert(all_ships, TEST_GS)


end

function love.quit()
    logger.info("The application is closing.")
    -- Perform your cleanup tasks here.
    if is_debug_on then
        love.profiler.stop()
        print(love.profiler.report(30))
    end
end

function love.update(dt)
    dt = math.min(dt, 1/60)
    flux.update(dt)
    player:update()


    --TEST_POS = get_point_along_line(6, dis)
    TEST_GS.position = get_point_along_line(6, 0)

    for b in table.for_each(bullets) do
        b:update()
    end


    for l in table.for_each(lines) do
        l.y = l.y + l.s

        if l.y >= 30 and l.y <= 50 then
            l.s = 0.4
            --elseif l.y >= 40 and l.y <= 60 then
            --l.s = 0.5
        elseif l.y >= 50 and l.y <= 85 then
            l.s = 0.5
        elseif l.y >= 85 and l.y <= 128 then
            l.s = 1.5
        end
        if l.y >= 128 then
            l.y = 30
        end
    end

    check_inputs()
    input:update()


    for s in table.for_each(all_ships) do
        s:update(dt)
    end
end

function check_inputs()
    if input:pressed 'left' then
        player:move('left')
        TEST_GS:change_lane(-1)
    end
    if input:pressed 'right' then
        player:move('right')
        TEST_GS:change_lane(1)
    end

    if input:down 'up' then
        TEST_GS.distance = TEST_GS.distance - 1
    end
    if input:down 'down' then
        TEST_GS.distance = TEST_GS.distance + 1
    end

    if input:pressed 'quit' then
        quit_game()
    end

    if input:pressed 'fire' then
        player:shoot_bullet()
    end

    if input:pressed 'missile' then
        player:shoot_missile()
        print("missile")
    end
end

function change_gamestate(state)
    gamestate = state
end

function love.draw()
    -- first translate, then scale
    love.graphics.translate(window.translateX, window.translateY)
    love.graphics.scale(window.scale)
    -- your graphics code here, optimized for fullHD


    --love.graphics.print("FPS: "..tostring(love.timer.getFPS( )), 0, 0, 0, 0.4, 0.4)
    love.graphics.print("dis: "..tostring(dis), 0, 0, 0, 0.4, 0.4)

    love.graphics.push("all")
    set_color_from_hex("#00c0c096")
    love.graphics.setLineWidth(0.5)
    love.graphics.line(0, 30, 227, 30)


    -- TODO: Remove math once positions are good
    --middle 

    love.graphics.line(LANES_POS[1][1].x, LANES_POS[1][1].y, LANES_POS[1][2].x, LANES_POS[1][2].y)
    love.graphics.line(LANES_POS[2][1].x, LANES_POS[2][1].y, LANES_POS[2][2].x, LANES_POS[2][2].y)
    love.graphics.line(LANES_POS[3][1].x, LANES_POS[3][1].y, LANES_POS[3][2].x, LANES_POS[3][2].y)
    love.graphics.line(LANES_POS[4][1].x, LANES_POS[4][1].y, LANES_POS[4][2].x, LANES_POS[4][2].y)
    love.graphics.line(LANES_POS[5][1].x, LANES_POS[5][1].y, LANES_POS[5][2].x, LANES_POS[5][2].y)
    love.graphics.line(LANES_POS[6][1].x, LANES_POS[6][1].y, LANES_POS[6][2].x, LANES_POS[6][2].y)
    love.graphics.line(LANES_POS[7][1].x, LANES_POS[7][1].y, LANES_POS[7][2].x, LANES_POS[7][2].y)
    love.graphics.line(LANES_POS[8][1].x, LANES_POS[8][1].y, LANES_POS[8][2].x, LANES_POS[8][2].y)
    love.graphics.line(LANES_POS[9][1].x, LANES_POS[9][1].y, LANES_POS[9][2].x, LANES_POS[9][2].y)

    -- love.graphics.line(226 / 2, 30, 226 / 2, 128)

    -- love.graphics.line(226 / 2 - 20, 30, 226 / 2 - 40, 128)
    -- love.graphics.line(226 / 2 + 20, 30, 226 / 2 + 40, 128)

    -- love.graphics.line(226 / 2 - 45, 30, 226 / 2 - 80, 128)
    -- love.graphics.line(226 / 2 + 45, 30, 226 / 2 + 80, 128)

    -- love.graphics.line(226 / 2 - 75, 30, 226 / 2 - 130, 128)
    -- love.graphics.line(226 / 2 + 75, 30, 226 / 2 + 130, 128)


    -- far right and left
    love.graphics.line(226 / 2 - 105, 30, 226 / 2 - 180, 128)
    love.graphics.line(226 / 2 + 105, 30, 267 / 2 + 180, 128)



    for l in table.for_each(lines) do
        if l.y >= 30 then
            love.graphics.line(0, l.y, 227, l.y)
        end
    end

    love.graphics.pop()

    for b in table.for_each(bullets) do
        b:draw()
    end


    for s in table.for_each(all_ships) do
        s:draw()
    end

    player:draw()

 

    --love.graphics.circle("fill", TEST_POS.x, TEST_POS.y, 2, 100)
end

function resize(w, h) -- update new translation and scale:
    local _w1, _h1 = window.width, window.height -- target rendering resolution
    local _scale = math.min(w / _w1, h / _h1)
    window.translateX, window.translateY, window.scale = (w - _w1 * _scale) / 2, (h - _h1 * _scale) / 2, _scale
end

function love.resize(w, h)
    resize(w, h) -- update new translation and scale
end

function quit_game()
    love.event.quit()
end

function table.for_each(list)
    local _i = 0
    return function()
        _i = _i + 1; return list[_i]
    end
end

function table.remove_item(table, item)
    for i, v in ipairs(table) do
        if v == item then
            table[i] = table[#table]
            table[#table] = nil
            return
        end
    end
end

function draw_pause()
    love.graphics.draw(pause_img, -50, 0)
    love.graphics.print("_", 49, 40 + (pause_index * 8))
    love.graphics.print("Resume", 57, 50, 0, 0.5, 0.5)
    love.graphics.print("quit", 57, 66, 0, 0.5, 0.5)
end

function is_on_screen(obj)
    if ((obj.x >= screen_rect.x + screen_rect.w) or
            (obj.x + obj.w <= screen_rect.x) or
            (obj.y >= screen_rect.y + screen_rect.h) or
            (obj.y + obj.h <= screen_rect.y)) then
        return false
    else
        return true
    end
end

function is_colliding(rect_a, rect_b)
    if ((rect_a.x >= rect_b.x + rect_b.w) or
            (rect_a.x + rect_a.w <= rect_b.x) or
            (rect_a.y >= rect_b.y + rect_b.h) or
            (rect_a.y + rect_a.h <= rect_b.y)) then
        return false
    else
        return true
    end
end

function save_high_score(score)
    if score > high_score then
        local file = love.filesystem.newFile("data.sav")
        file:open("w")
        file:write(score)
        file:close()
    end
end

function load_high_score()
    local score, _ = love.filesystem.read("data.sav")
    score = tonumber(score)
    return score or 0
end
