if ONCE.start then
    ONCE.start = false
    local setColor = love.graphics.setColor
    love.graphics.setColor = function(r, g, b, a)
        local function c(a)
            if type(a) == 'number' then
                return a / 255
            elseif type(a) == 'table' then
                local t = {}
                for i, v in ipairs(a) do
                    table.insert(t, v / 255)
                end
                return t
            end
        end
        setColor(c(r), c(g), c(b), c(a))
    end
end

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

local t
t = {
    function ()
        drawBackground()

        local function drawEye(eyeX, eyeY)
            local distanceX = mouseX - eyeX
            local distanceY = mouseY - eyeY
            local distance = math.sqrt(distanceX^2 + distanceY^2)
            local angle = math.atan2(distanceY, distanceX)

            local eyeMaxPupilDistance = 30
            if distance > eyeMaxPupilDistance then
                distance = eyeMaxPupilDistance
            end

            local pupilX = eyeX + (math.cos(angle) * distance)
            local pupilY = eyeY + (math.sin(angle) * distance)

            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', eyeX, eyeY, 50)

            love.graphics.setColor(0, 0, 100)
            love.graphics.circle('fill', pupilX, pupilY, 15)
        end

        drawEye(200, 200)
        drawEye(330, 200)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', 200, 200, 15)
    end,
    function ()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY

        local output = {}

        table.insert(output, 'distance x: '..distanceX)
        table.insert(output, 'distance y: '..distanceY)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print(table.concat(output, '\n'))

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', 200, 200, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)

        local output = {}

        table.insert(output, 'distance x: '..distanceX)
        table.insert(output, 'distance y: '..distanceY)
        table.insert(output, 'distance: '..distance)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print(table.concat(output, '\n'))

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', 200, 200, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceY, distanceX)

        local output = {}

        table.insert(output, 'distance x: '..distanceX)
        table.insert(output, 'distance y: '..distanceY)
        table.insert(output, 'distance: '..distance)
        table.insert(output, 'angle: '..angle)

        love.graphics.setColor(255, 255, 255)
        love.graphics.print(table.concat(output, '\n'))

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', 200, 200, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceY, distanceX)
        local pupilX = eyeX + (math.cos(angle) * distance)
        local pupilY = eyeY + (math.sin(angle) * distance)

        local output = {}

        table.insert(output, 'distance x: '..distanceX)
        table.insert(output, 'distance y: '..distanceY)
        table.insert(output, 'distance: '..distance)
        table.insert(output, 'angle: '..angle)
        table.insert(output, 'cos(angle): '..math.cos(angle))
        table.insert(output, 'sin(angle): '..math.sin(angle))

        love.graphics.setColor(255, 255, 255)
        love.graphics.print(table.concat(output, '\n'))

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', pupilX, pupilY, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        local eyeX = 200
        local eyeY = 200

        local distanceX = mouseX - eyeX
        local distanceY = mouseY - eyeY
        local distance = math.sqrt(distanceX^2 + distanceY^2)
        local angle = math.atan2(distanceY, distanceX)

        local eyeMaxPupilDistance = 30
        if distance > eyeMaxPupilDistance then
            distance = eyeMaxPupilDistance
        end

        local pupilX = eyeX + (math.cos(angle) * distance)
        local pupilY = eyeY + (math.sin(angle) * distance)

        local output = {}

        table.insert(output, 'distance x: '..distanceX)
        table.insert(output, 'distance y: '..distanceY)
        table.insert(output, 'distance: '..distance)
        table.insert(output, 'angle: '..angle)
        table.insert(output, 'cos(angle): '..math.cos(angle))
        table.insert(output, 'sin(angle): '..math.sin(angle))

        love.graphics.setColor(255, 255, 255)
        love.graphics.print(table.concat(output, '\n'))

        love.graphics.setColor(255, 255, 255)
        love.graphics.circle('fill', 200, 200, 50)

        love.graphics.setColor(0, 0, 100)
        love.graphics.circle('fill', pupilX, pupilY, 15)

        drawMouse(mouseX, mouseY)
    end,
    function ()
        drawBackground()

        local function drawEye(eyeX, eyeY)
            local distanceX = mouseX - eyeX
            local distanceY = mouseY - eyeY
            local distance = math.sqrt(distanceX^2 + distanceY^2)
            local angle = math.atan2(distanceY, distanceX)

            local eyeMaxPupilDistance = 30
            if distance > eyeMaxPupilDistance then
                distance = eyeMaxPupilDistance
            end

            local pupilX = eyeX + (math.cos(angle) * distance)
            local pupilY = eyeY + (math.sin(angle) * distance)

            love.graphics.setColor(255, 255, 255)
            love.graphics.circle('fill', eyeX, eyeY, 50)

            love.graphics.setColor(0, 0, 100)
            love.graphics.circle('fill', pupilX, pupilY, 15)
        end

        drawEye(200, 200)
        drawEye(330, 200)

        drawMouse(mouseX, mouseY)
    end
}

return t
