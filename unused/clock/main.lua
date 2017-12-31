function love.draw()    
    center_x = love.graphics.getWidth()  / 2
    center_y = love.graphics.getHeight() / 2

    love.graphics.circle('fill', center_x, center_y, 5)

    radius = 100
    
    for marker_number = 1, 12 do
        local angle = 2*math.pi/12 * marker_number
        local marker_x = center_x + math.cos(angle) * radius
        local marker_y = center_y + math.sin(angle) * radius
        love.graphics.circle('fill', marker_x, marker_y, 4)
    end

    time = os.date('*t')

    normalised_seconds =  time.sec / 60
    normalised_minutes = (time.min  + normalised_seconds) / 60
    normalised_hours   = (time.hour + normalised_minutes) / 12

    second_angle = normalised_seconds * 2*math.pi - 2*math.pi/4
    minute_angle = normalised_minutes * 2*math.pi - 2*math.pi/4
    hour_angle   = normalised_hours   * 2*math.pi - 2*math.pi/4

    second_hand_length = 80
    minute_hand_length = 60
    hour_hand_length   = 40
    
    second_hand_x = center_x + math.cos(second_angle) * second_hand_length
    second_hand_y = center_y + math.sin(second_angle) * second_hand_length
    minute_hand_x = center_x + math.cos(minute_angle) * minute_hand_length
    minute_hand_y = center_y + math.sin(minute_angle) * minute_hand_length
    hour_hand_x   = center_x + math.cos(hour_angle)   * hour_hand_length
    hour_hand_y   = center_y + math.sin(hour_angle)   * hour_hand_length

    love.graphics.setLineWidth(2)
    love.graphics.line(center_x, center_y, second_hand_x, second_hand_y)
    love.graphics.setLineWidth(3)
    love.graphics.line(center_x, center_y, minute_hand_x, minute_hand_y)
    love.graphics.setLineWidth(4)
    love.graphics.line(center_x, center_y, hour_hand_x, hour_hand_y)
end
