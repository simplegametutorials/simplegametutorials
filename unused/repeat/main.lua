function love.load()
    history = {}
    function new()
        table.insert(history, love.math.random(4))
    end
    new()

    current = 1
    state = 'watch' -- 'watch', 'repeat', 'game over'
    flashing = true
    timer = 0
    timerLimit = 0.5

    love.graphics.setNewFont(20)
end

function love.update(dt)
    if state == 'watch' then
        timer = timer + dt
        if timer >= timerLimit then
            timer = 0
            flashing = not flashing
            if not flashing then
                current = current + 1
                if current > #history then
                    state = 'repeat'
                    current = 1
                end
            end
        end
    end
end

function love.draw()
    local function drawSquare(number, color)
        local function lerp(a, b, t)
            return (1 - t) * a + t * b
        end

        local multiplier
        local mutiplierStart = 1
        local mutiplierEnd = 0.4

        local y
        local yStart = 30
        local yEnd = 0

        if flashing and number == history[current] then
            multiplier = lerp(mutiplierStart, mutiplierEnd, timer / timerLimit)
            y = lerp(yStart, yEnd, timer / timerLimit)
        else
            multiplier = mutiplierEnd
            y = yEnd
        end

        local squareSize = 50
        love.graphics.setColor(color[1] * multiplier, color[2] * multiplier, color[3] * multiplier)
        love.graphics.rectangle('fill', (number - 1) * squareSize, y, squareSize, squareSize)
        love.graphics.setColor(1, 1, 1)		
		love.graphics.print(number, (number - 1) * squareSize + 19, y + 14)
    end

    drawSquare(1, {1, 0, 0})
    drawSquare(2, {0, 1, 0})
    drawSquare(3, {0, 0, 1})
    drawSquare(4, {1, 1, 0})

    local output = ''
    if state == 'repeat' then
        output = current..'/'..#history
    elseif state == 'game over' then
        output = 'Game over!'
    end
    love.graphics.print(output, 20, 60)
end

function love.keypressed(key)
    if state == 'repeat' then
        if tonumber(key) == history[current] then
            current = current + 1
            if current > #history then
                state = 'watch'
                timer = 0
                new()
                current = 1
                flashing = true
            end
        else
            state = 'game over'
        end
    elseif state == 'game over' then
        love.load()
    end
end

