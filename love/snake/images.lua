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

local font = love.graphics.newFont('SourceCodePro-Regular.ttf', 15)
local cellXCount = 20
local cellYCount = 15
local cellSize = 15
local colorDead = {126, 126, 126}
local colorAlive = {153, 255, 81}
local colorFood = {255, 76, 76}
local colorBackground = {71, 71, 71}

local function drawBackground()
    love.graphics.setColor(colorBackground)
    love.graphics.rectangle(
        'fill',
        0,
        0,
        cellXCount * cellSize,
        cellYCount * cellSize
    )
end

local function drawCell(x, y)
    love.graphics.rectangle(
        'fill',
        (x - 1) * cellSize,
        (y - 1) * cellSize,
        cellSize - 1,
        cellSize - 1)
end

local t
t = {
    function()
        drawBackground()
        local foodPosition = {x = 10, y = 3}
        local x = 1
        local y = 10
        local snakeSegments = {
            {x = x + cellXCount - 1, y = y},
            {x = x + cellXCount - 2, y = y},
            {x = x + cellXCount - 3, y = y},

            {x = x, y = y},
            {x = x+1, y = y},
            {x = x+1, y = y+1},
            {x = x+1, y = y+2},
            {x = x+2, y = y+2},
            {x = x+3, y = y+2},
            {x = x+4, y = y+2},
            {x = x+4, y = y+1},
            {x = x+4, y = y},
            {x = x+4, y = y-1},
            {x = x+5, y = y-1},
            {x = x+5, y = y-2},
            {x = x+5, y = y-3},
            {x = x+5, y = y-4},
            {x = x+5, y = y-5},
            {x = x+5, y = y-6},
            {x = x+5, y = y-7},
            {x = x+6, y = y-7},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
    end,

    function()
        drawBackground()
        local foodPosition = {x = 10, y = 3}
        local foodPosition = {x = 12, y = 7}
        local x = 7
        local y = 7
        local snakeSegments = {
            {x = x+3, y = y},
            {x = x+2, y = y},
            {x = x+1, y = y},
            {x = x, y = y},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            if segmentIndex == 1 then
                --love.graphics.setColor(255, 200, 20)
            end
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
        --
        love.graphics.setFont(font)
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(0, 0, 0)
            love.graphics.print('{x = '..segment.x..', y = '..segment.y..'},', 330, 20 * segmentIndex)
        end
        love.graphics.print('{', 310, 0)
        love.graphics.print('}', 310, 20 * (#snakeSegments + 1))
    end,

    function()
        drawBackground()
        local foodPosition = {x = 12, y = 7}
        local x = 8
        local y = 7
        local snakeSegments = {
            {x = x+3, y = y},
            {x = x+2, y = y},
            {x = x+1, y = y},
            {x = x, y = y},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            if segmentIndex == 1 then
                --love.graphics.setColor(255, 200, 20)
            end
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
        --
        love.graphics.setFont(font)
        local snakeSegments = {
            {x = x+3, y = y},
            {x = x+2, y = y},
            {x = x+1, y = y},
            {x = x, y = y},
            {x = x-1, y = y},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(0, 0, 0)
            love.graphics.print('{x = '..segment.x..', y = '..segment.y..'},', 330, 20 * segmentIndex)
        end
        love.graphics.print('{', 310, 0)
        love.graphics.print('}', 310, 20 * (#snakeSegments + 1))
        love.graphics.setColor(255, 0, 0)
        love.graphics.rectangle('fill', 325, 20 * 5 + 10, 155, 2)
    end,
    function()
        drawBackground()
        local foodPosition = {x = 3, y = 3}
        local x = 8
        local y = 7
        local snakeSegments = {
            {x = x+4, y = y},
            {x = x+3, y = y},
            {x = x+2, y = y},
            {x = x+1, y = y},
            {x = x, y = y},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            if segmentIndex == 1 then
                --love.graphics.setColor(255, 200, 20)
            end
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
        --
        love.graphics.setFont(font)
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(0, 0, 0)
            love.graphics.print('{x = '..segment.x..', y = '..segment.y..'},', 330, 20 * segmentIndex)
        end
        love.graphics.print('{', 310, 0)
        love.graphics.print('}', 310, 20 * (#snakeSegments + 1))
        love.graphics.setColor(255, 0, 0)
    end,
    function()
        drawBackground()
    end,
    function()
        drawBackground()
        local snakeSegments = {
            {x = 1, y = 1},
            {x = 2, y = 1},
            {x = 3, y = 1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
    end,
    function()
        drawBackground()
        local snakeSegments = {
            {x = 1+10, y = 1},
            {x = 2+10, y = 1},
            {x = 3+10, y = 1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
    end,
    function()
        drawBackground()
        local x = 10
        local y = 7
        local snakeSegments = {
            {x = x, y = y},
            {x = x, y = y+1},
            {x = x+1, y = y+1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
    end,
    function()
        drawBackground()
        local x = 10
        local y = 7
        local snakeSegments = {
            {x = x, y = y},
            {x = x, y = y+1},
            {x = x+1, y = y+1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end

        local directionQueue = {'right', 'down'}

        for directionIndex, direction in ipairs(directionQueue) do
            love.graphics.setColor(255, 255, 255)
            love.graphics.print('directionQueue['..directionIndex..']: '..direction, 15, 15 * directionIndex)
        end
    end,
    function()
        drawBackground()
        local y = 8
        local snakeSegments = {
            {x = 1, y = y},
            {x = cellXCount, y = y},
            {x = cellXCount - 1, y = y},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
    end,
    function()
        drawBackground()
        local foodPosition = {x = 10, y = 10}
        local x = 10
        local y = 7
        local snakeSegments = {
            {x = 1, y = 1},
            {x = 2, y = 1},
            {x = 3, y = 1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(colorAlive)
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
    end,
    function()
        drawBackground()
        local foodPosition = {x = 10, y = 10}
        local x = 7
        local y = 5
        local snakeSegments = {
            {x = x+1, y = y},
            {x = x+2, y = y},
            {x = x+3, y = y},
            {x = x+4, y = y},
            {x = x+5, y = y},
            {x = x+6, y = y},
            {x = x+6, y = y+1},
            {x = x+6, y = y+2},
            {x = x+5, y = y+2},
            {x = x+4, y = y+2},
            {x = x+4, y = y+1},
        }
        for segmentIndex, segment in ipairs(snakeSegments) do
            love.graphics.setColor(140, 140, 140)
            drawCell(segment.x, segment.y)
        end
        love.graphics.setColor(colorFood)
        drawCell(foodPosition.x, foodPosition.y)
    end,
}
return t
