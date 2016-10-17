local t
local mouse = love.graphics.newImage('mouse.png')
local function drawBackground()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, 200+330, 200+200)
end
local function drawEye()
    love.graphics.setColor(255, 255, 255)
    love.graphics.circle('fill', 200, 200, 50)
    love.graphics.setColor(0, 0, 100)
    love.graphics.circle('fill', 200, 200, 15)
end
local function drawMouse(mouseX, mouseY)
    love.graphics.setColor(255, 255, 100)
    love.graphics.draw(mouse, mouseX, mouseY)
end

local mouseX = 387
local mouseY = 132

t = {
    function ()
        drawBackground()

        function drawEye(eyeX, eyeY)
            local distanceX = mouseX - eyeX
            local distanceY = mouseY - eyeY
            local distance = math.sqrt(distanceX^2 + distanceY^2)
            local angle = math.atan2(distanceX, distanceY)

            local eyeMaxPupilDistance = 30
            if distance > eyeMaxPupilDistance then
                distance = eyeMaxPupilDistance
            end

            local pupilX = eyeX + (math.sin(angle) * distance)
            local pupilY = eyeY + (math.cos(angle) * distance)

            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', eyeX, eyeY, 50)

            love.graphics.setColor(0, 0, 100)
            love.graphics.circle('fill', pupilX, pupilY, 15)
        end

        drawEye(200, 200)
        drawEye(330, 200)

        drawMouse(mouseX, mouseY)
    end,
    --[[
    function()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceX, distanceY)

        love.graphics.setColor(255, 255, 255)
        --love.graphics.print('distance x: '..distanceX, 15, 15)
        --love.graphics.print('distance y: '..distanceY, 15, 30)
        --love.graphics.print('distance: '..distance, 15, 45)
        --love.graphics.print('angle: '..angle, 15, 60)

        
        local eyeMaxPupilDistance = 30
        if distance > eyeMaxPupilDistance then
            distance = eyeMaxPupilDistance
        end

        local pupilX = eyeX + (math.sin(angle) * distance)
        local pupilY = eyeY + (math.cos(angle) * distance)

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', eyeX, eyeY, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', pupilX, pupilY, 15)

        love.graphics.setColor(0, 0, 100)
        love.graphics.setLineWidth(1)

        love.graphics.setColor(0, 255, 255)
        love.graphics.line(eyeX, eyeY, mouseX, mouseY)
        love.graphics.line(mouseX, mouseY, mouseX, eyeY)
        love.graphics.line(eyeX, eyeY, mouseX, eyeY)

        love.graphics.setColor(255, 255, 255)
        love.graphics.printf('x', eyeX, eyeY + 3, mouseX - eyeX, 'center')

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('y', mouseX + 6, eyeY - 38)
        love.graphics.setColor(255, 0, 0)
        love.graphics.line(eyeX, eyeY, pupilX, pupilY)

        drawMouse(mouseX, mouseY)
    end,
    --]]
    function()
        drawBackground()
        drawEye()
    end,
    function()
        drawBackground()
        drawEye()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('distance x: '..distanceX, 15, 15)
        love.graphics.print('distance y: '..distanceY, 15, 30)

        drawMouse(mouseX, mouseY)
    end,
    function()
        drawBackground()
        drawEye()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('distance x: '..distanceX, 15, 15)
        love.graphics.print('distance y: '..distanceY, 15, 30)
        love.graphics.print('distance: '..distance, 15, 45)

        drawMouse(mouseX, mouseY)
    end,
    function()
        drawBackground()
        drawEye()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceX, distanceY)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('distance x: '..distanceX, 15, 15)
        love.graphics.print('distance y: '..distanceY, 15, 30)
        love.graphics.print('distance: '..distance, 15, 45)
        love.graphics.print('angle: '..angle, 15, 60)

        drawMouse(mouseX, mouseY)
    end,
    function()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceX, distanceY)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('distance x: '..distanceX, 15, 15)
        love.graphics.print('distance y: '..distanceY, 15, 30)
        love.graphics.print('distance: '..distance, 15, 45)
        love.graphics.print('angle: '..angle, 15, 60)

        local pupilX = eyeX + (math.sin(angle) * distance)
        local pupilY = eyeY + (math.cos(angle) * distance)

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', eyeX, eyeY, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', pupilX, pupilY, 15)

        drawMouse(mouseX, mouseY)
    end,
    function()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceX, distanceY)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print('distance x: '..distanceX, 15, 15)
        love.graphics.print('distance y: '..distanceY, 15, 30)
        love.graphics.print('distance: '..distance, 15, 45)
        love.graphics.print('angle: '..angle, 15, 60)

        
        local eyeMaxPupilDistance = 30
        if distance > eyeMaxPupilDistance then
            distance = eyeMaxPupilDistance
        end

        local pupilX = eyeX + (math.sin(angle) * distance)
        local pupilY = eyeY + (math.cos(angle) * distance)

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', eyeX, eyeY, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', pupilX, pupilY, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        function drawEye(eyeX, eyeY)
            local distanceX = mouseX - eyeX
            local distanceY = mouseY - eyeY
            local distance = math.sqrt(distanceX^2 + distanceY^2)
            local angle = math.atan2(distanceX, distanceY)

            local eyeMaxPupilDistance = 30
            if distance > eyeMaxPupilDistance then
                distance = eyeMaxPupilDistance
            end

            local pupilX = eyeX + (math.sin(angle) * distance)
            local pupilY = eyeY + (math.cos(angle) * distance)

            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', eyeX, eyeY, 50)

            love.graphics.setColor(0, 0, 100)
            love.graphics.circle('fill', pupilX, pupilY, 15)
        end

        drawEye(200, 200)
        drawEye(330, 200)

        drawMouse(mouseX, mouseY)
    end,
}
return t
