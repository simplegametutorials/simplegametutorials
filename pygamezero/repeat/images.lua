local pygamefont = love.graphics.newFont('freesansbold.ttf', 16)

local t

local testSequence = {4, 3, 1, 2, 2, 3}

local numberY = 18

local numberX = 21

local function drawBackground(x, y)
    love.graphics.push('all')
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, x or 200, y or 90)
    love.graphics.pop()
end

t = {
    function ()
        love.graphics.setFont(pygamefont)
        
        drawBackground()
        local sequence = testSequence
        local current = 3
        local state = 'watch'

        local function drawSquare(number, color, colorFlashing)
            local squareSize = 50

            if number == sequence[current] then
                love.graphics.setColor(colorFlashing)
            else
                love.graphics.setColor(color)
            end

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end
        
        drawSquare(1, {.2, 0, 0}, {1, 0, 0})
        drawSquare(2, {0, .2, 0}, {0, 1, 0})
        drawSquare(3, {0, 0, .2}, {0, 0, 1})
        drawSquare(4, {.2, .2, 0}, {1, 1, 0})

        love.graphics.print(current..'/'..#sequence, 20, 60)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        drawBackground()
        local sequence = testSequence
        love.graphics.print(table.concat(sequence, ', '))
    end,
    function ()
        love.graphics.setFont(pygamefont)

        drawBackground()
        local sequence = testSequence
        local current = 2
        love.graphics.print(table.concat(sequence, ', '))
        love.graphics.print(current..'/'..#sequence, 0, 20)
        love.graphics.print('sequence[current]: '..sequence[current], 0, 40)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground(300, 182)
        local sequence = testSequence
        local current = 1
        
        local squareSize = 50

        love.graphics.setColor(.2, 0, 0)
        love.graphics.rectangle('fill', 0, 0, squareSize, squareSize)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(1, 19, numberY)
        love.graphics.print(current..'/'..#sequence, 20, 60)
        love.graphics.print('sequence[current]: '..sequence[current], 20, 100)
        love.graphics.print(table.concat(sequence, ', '), 20, 140)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground(300, 182)
        local sequence = testSequence
        local current = 1

        local function drawSquare(number, color)
            local squareSize = 50

            love.graphics.setColor(color)

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end

        
        drawSquare(1, {.2, 0, 0})
        drawSquare(2, {0, .2, 0})
        drawSquare(3, {0, 0, .2})
        drawSquare(4, {.2, .2, 0})

        love.graphics.print(current..'/'..#sequence, 20, 60)
        love.graphics.print('sequence[current]: '..sequence[current], 20, 100)
        love.graphics.print(table.concat(sequence, ', '), 20, 140)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground(300, 182)
        local sequence = testSequence
        local current = 2

        local function drawSquare(number, color)
            local squareSize = 50

            if number == sequence[current] then
                love.graphics.setColor(color)
            else
                love.graphics.setColor(0, 0, 0)
            end

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end

        
        drawSquare(1, {.2, 0, 0})
        drawSquare(2, {0, .2, 0})
        drawSquare(3, {0, 0, .2})
        drawSquare(4, {.2, .2, 0})

        love.graphics.print(current..'/'..#sequence, 20, 60)
        love.graphics.print('sequence[current]: '..sequence[current], 20, 100)
        love.graphics.print(table.concat(sequence, ', '), 20, 140)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground(300, 182)
        local sequence = testSequence
        local current = 2

        local function drawSquare(number, color, colorFlashing)
            local squareSize = 50

            if number == sequence[current] then
                love.graphics.setColor(colorFlashing)
            else
                love.graphics.setColor(color)
            end

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end

        
        drawSquare(1, {.2, 0, 0}, {1, 0, 0})
        drawSquare(2, {0, .2, 0}, {0, 1, 0})
        drawSquare(3, {0, 0, .2}, {0, 0, 1})
        drawSquare(4, {.2, .2, 0}, {1, 1, 0})

        love.graphics.print(current..'/'..#sequence, 20, 60)
        love.graphics.print('sequence[current]: '..sequence[current], 20, 100)
        love.graphics.print(table.concat(sequence, ', '), 20, 140)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground(300, 220)
        local sequence = testSequence
        local current = 2
        local state = 'watch'

        local function drawSquare(number, color, colorFlashing)
            local squareSize = 50

            if number == sequence[current] then
                love.graphics.setColor(colorFlashing)
            else
                love.graphics.setColor(color)
            end

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end

        
        drawSquare(1, {.2, 0, 0}, {1, 0, 0})
        drawSquare(2, {0, .2, 0}, {0, 1, 0})
        drawSquare(3, {0, 0, .2}, {0, 0, 1})
        drawSquare(4, {.2, .2, 0}, {1, 1, 0})

        love.graphics.print(current..'/'..#sequence, 20, 60)
        love.graphics.print('sequence[current]: '..sequence[current], 20, 100)
        love.graphics.print(table.concat(sequence, ', '), 20, 140)
        love.graphics.print('state: '..state, 20, 180)
    end,
    function ()
        love.graphics.setFont(pygamefont)

        
        drawBackground()
        local sequence = testSequence
        local current = 2
        local state = 'watch'

        local function drawSquare(number, color, colorFlashing)
            local squareSize = 50

            love.graphics.setColor(color)

            love.graphics.rectangle('fill', squareSize * (number - 1), 0, squareSize, squareSize)
            love.graphics.setColor(1, 1, 1)        
            love.graphics.print(number, squareSize * (number - 1) + numberX, numberY)
        end
        
        drawSquare(1, {.2, 0, 0}, {1, 0, 0})
        drawSquare(2, {0, .2, 0}, {0, 1, 0})
        drawSquare(3, {0, 0, .2}, {0, 0, 1})
        drawSquare(4, {.2, .2, 0}, {1, 1, 0})

        love.graphics.print('Game over!', 20, 60)
    end,
}

return t
