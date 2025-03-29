
function get_next_time(min_sec, max_sec)
    local _min = min_sec * 60
    local _max = max_sec * 60
    return math.random(_min, _max)
end

function set_color_from_hex(rgba)
    --setColorHEX(rgba)
    --where rgba is string as "#336699cc"
    local _rb = tonumber(string.sub(rgba, 2, 3), 16)
    local _gb = tonumber(string.sub(rgba, 4, 5), 16)
    local _bb = tonumber(string.sub(rgba, 6, 7), 16)
    local _ab = tonumber(string.sub(rgba, 8, 9), 16) or nil
    --print (rb, gb, bb, ab) -- prints 51102153204
    --print (love.math.colorFromBytes( rb, gb, bb, ab )) -- prints0.20.40.60.8
    love.graphics.setColor(love.math.colorFromBytes(_rb, _gb, _bb, _ab))
end

function draw_hitbox(obj)
    love.graphics.push("all")
    set_color_from_hex("#ff0000")
    love.graphics.rectangle("line", obj.x, obj.y, obj.w, obj.h)
    love.graphics.pop()
end

function angle_lerp(angle1, angle2, t)
    angle1 = angle1 % 1
    angle2 = angle2 % 1

    if math.abs(angle1 - angle2) > 0.5 then
        if angle1 > angle2 then
            angle2 = angle2 + 1
        else
            angle1 = angle1 + 1
        end
    end

    return ((1 - t) * angle1 + t * angle2) % 1
end

function get_angle(x1, y1, x2, y2)
    return math.atan2(x2 - x1, y2 - y1)
end

function get_distance(obj_a, obj_b)
    local _dx = obj_a.x - obj_b.x
    local _dy = obj_a.y - obj_b.y
    return math.sqrt(_dx * _dx + _dy * _dy)
end

function math.clamp(low, n, high)
    return math.min(math.max(n, low), high)
end


function get_point_along_line(start_vec2, end_vec2, dist)
    local dx, dy = end_vec2.x - start_vec2.x, end_vec2.y - start_vec2.y
    local length = math.sqrt(dx * dx + dy * dy)
  
    if length == 0 then
        return Vec2:new(start_vec2.x, start_vec2.y)
    end
  
    local scale = dist / length
    return Vec2:new(start_vec2.x + dx * scale, start_vec2.y + dy * scale)
  end


  function get_point_along_line(lane, dist)
    local dx, dy = LANES_POS[lane][2].x - LANES_POS[lane][1].x, LANES_POS[lane][2].y - LANES_POS[lane][1].y
    local length = math.sqrt(dx * dx + dy * dy)
  
    if length == 0 then
        return Vec2:new(LANES_POS[lane][1].x, LANES_POS[lane][1].y)
    end
  
    local scale = dist / length
    return Vec2:new(LANES_POS[lane][1].x+ dx * scale, LANES_POS[lane][1].y + dy * scale)
  end



  function all(_list)
    local i = 0
    return function()
        i = i + 1; return _list[i]
    end
end