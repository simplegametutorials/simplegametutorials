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
local cellXCount = 70
local cellYCount = 50
local cellSize = 5
local cellDrawSize = cellSize - 1
local colorDead = {220, 220, 220}
local colorAlive = {255, 0, 255}
local colorSelected = {0, 255, 255}
local mouseX = 132
local mouseY = 103
local selectedX = math.floor(mouseX / cellSize) + 1
local selectedY = math.floor(mouseY / cellSize) + 1
local function drawBackground()
    love.graphics.setColor(255, 255, 255)
    love.graphics.rectangle('fill', 0, 0, cellXCount * cellSize, cellYCount * cellSize)
end
local font = love.graphics.newFont('SourceCodePro-Regular.ttf', 12)
love.graphics.setNewFont(14)
local function updateGrid(grid)
    local nextGrid = {}
    for y = 1, cellYCount do
        nextGrid[y] = {}
        for x = 1, cellXCount do
            local neighbors = 0
            for ny = -1, 1 do
                for nx = -1, 1 do
                    if not (ny == 0 and nx == 0)
                    and grid[y + ny]
                    and grid[y + ny][x + nx] == true then
                        neighbors = neighbors + 1
                    end
                end
            end

            nextGrid[y][x] = neighbors == 3 or (grid[y][x] == true and neighbors == 2)
        end
    end

    return nextGrid
end
local function drawTable(t)
    love.graphics.push('all')
    local blockSize = 40
    local blockDrawSize = blockSize - 1
    local moveSize = blockSize + 10
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('{', 0, 1)
    love.graphics.translate(10, 0)
    for x = 1, #t do
        if t[x] then
            love.graphics.setColor(colorAlive)
        else
            love.graphics.setColor(colorDead)
        end
        love.graphics.rectangle(
            'fill',
            (x - 1) * moveSize,
            - 9,
            blockDrawSize,
            blockDrawSize
        )
        if t[x] then
            love.graphics.setColor(255, 255, 255)
        else
            love.graphics.setColor(0, 0, 0)
        end
        local function f2(s)
            love.graphics.print(
                s,
                (x - 1) * moveSize + 20,
                1
            )
        end
        local function f(s)
            love.graphics.printf(
                s,
                (x - 1) * moveSize + 0,
                1, blockSize, 'center'
            )
        end
        if t[x] then
            f('true')
        else
            f('false')
        end
        love.graphics.setColor(0, 0, 0)
        if x ~= #t then
            f2('   ,')
        end
    end
    love.graphics.print('},', #t * moveSize - 8, 1)
    love.graphics.pop()
end

local function drawTable2(t)
    love.graphics.setFont(font)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('{', 0, 0)

    love.graphics.push('all')
    love.graphics.translate(20, 20)
    for y = 1, #t do
        drawTable(t[y])
        love.graphics.translate(0, 50)
    end
    love.graphics.pop()

    love.graphics.print('}', 0, #t * 50 + 10)
end
local t
t = {
    function()
        drawBackground()
        if not thisGrid then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        local selectedX = math.floor(love.mouse.getX() / cellSize) + 1
        local selectedY = math.floor(love.mouse.getY() / cellSize) + 1

        if love.mouse.isDown(1) then
            thisGrid[selectedY][selectedX] = true
        elseif love.mouse.isDown(2) then
            thisGrid[selectedY][selectedX] = false
        end

        if love.keyboard.isDown('c') then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        grid = thisGrid

        if ONCE.z or ONCE.a then
            ONCE.z = false
            ONCE.a = false
            local nextGrid = {}
            for y = 1, cellYCount do
                nextGrid[y] = {}
                for x = 1, cellXCount do
                    local neighborCount = 0

                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dy == 0 and dx == 0)
                            and grid[y + dy]
                            and grid[y + dy][x + dx] then
                                neighborCount = neighborCount + 1
                            end
                        end
                    end

                    nextGrid[y][x] = neighborCount == 3 or (grid[y][x] and neighborCount == 2)
                end
            end
            thisGrid = nextGrid
        end


        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    love.graphics.setColor(colorSelected)
                elseif thisGrid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end

        love.graphics.setColor(255, 255, 100)
    end,
    function ()
        local grid = {
            {false, false, false, false, false},
            {false, false, true, false, false},
            {false, true, false, false, false},
            {false, true, true, true, false},
            {false, false, false, false, false},
        }
        drawTable2(grid)
    end,
    --[[
    function ()
        local grid = {
            {false, false, false, false, false},
            {false, false, false, false, false},
            {false, true, false, true, false},
            {false, true, true, false, false},
            {false, false, true, false, false},
        }
        drawTable2(grid)
    end,
    --]]
    function()
        --drawBackground()

        local cellXCount = 10
        local cellYCount = 10
        local scale = 4
        local cellSize = 5 * scale
        local cellDrawSize = cellSize - 1 * scale
        if not thisGrid then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        local selectedX = math.floor(love.mouse.getX() / cellSize) + 1
        local selectedY = math.floor(love.mouse.getY() / cellSize) + 1

        if love.mouse.isDown(1) then
            thisGrid[selectedY][selectedX] = true
        elseif love.mouse.isDown(2) then
            thisGrid[selectedY][selectedX] = false
        end

        if love.keyboard.isDown('c') then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        grid = thisGrid

        love.graphics.setColor(255, 255, 255)
        love.graphics.rectangle('fill', 0, 0, cellXCount * cellSize, cellYCount * cellSize)

        if ONCE.z or ONCE.a then
            ONCE.z = false
            ONCE.a = false
            local nextGrid = {}
            for y = 1, cellYCount do
                nextGrid[y] = {}
                for x = 1, cellXCount do
                    local neighborCount = 0

                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dy == 0 and dx == 0)
                            and grid[y + dy]
                            and grid[y + dy][x + dx] then
                                neighborCount = neighborCount + 1
                            end
                        end
                    end

                    nextGrid[y][x] = neighborCount == 3 or (grid[y][x] and neighborCount == 2)
                end
            end
            thisGrid = nextGrid
        end


        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    love.graphics.setColor(colorSelected)
                elseif thisGrid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
                love.graphics.setColor(0, 0, 0)

                local neighborCount = 0
                for dy = -1, 1 do
                    for dx = -1, 1 do
                        if not (dy == 0 and dx == 0)
                        and thisGrid[y + dy]
                        and thisGrid[y + dy][x + dx] then
                            neighborCount = neighborCount + 1
                        end
                    end
                end

                love.graphics.print(neighborCount, (x - 1) * cellSize + 3, (y - 1) * cellSize)
            end
        end

        love.graphics.setColor(255, 255, 100)
    end,
    function()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, cellXCount * cellSize, cellYCount * cellSize)
        love.graphics.setColor(255, 255, 255)
        for y = 1, 1 do
            for x = 1, 1 do
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, cellXCount * cellSize, cellYCount * cellSize)
        love.graphics.setColor(255, 255, 255)
        for y = 1, 1 do
            for x = 1, cellXCount do
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, cellXCount * cellSize, cellYCount * cellSize)
        love.graphics.setColor(255, 255, 255)
        for y = 1, cellYCount do
            for x = 1, cellXCount do
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        drawBackground()
        love.graphics.setColor(colorDead)
        for y = 1, cellYCount do
            for x = 1, cellXCount do
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        drawBackground()
        for y = 1, cellYCount do
            for x = 1, cellXCount do
                love.graphics.setColor(colorDead)
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print('selected x: '..selectedX..', selected y: '..selectedY)
        
    end,
    function()
        drawBackground()
        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    love.graphics.setColor(colorSelected)
                else
                    love.graphics.setColor(colorDead)
                end
                    love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
    end,
    function()
        drawBackground()
        local grid = {}
        for y = 1, cellYCount do
            grid[y] = {}
            for x = 1, cellXCount do
                grid[y][x] = false
            end
        end

        grid[1][1] = true
        grid[1][2] = true

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    --love.graphics.setColor(colorSelected)
                    love.graphics.setColor(colorDead)
                elseif grid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        drawBackground()
        if not thisGrid then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        local selectedX = math.floor(love.mouse.getX() / cellSize) + 1
        local selectedY = math.floor(love.mouse.getY() / cellSize) + 1

        if love.mouse.isDown(1) then
            thisGrid[selectedY][selectedX] = true
        elseif love.mouse.isDown(2) then
            thisGrid[selectedY][selectedX] = false
        end

        if love.keyboard.isDown('c') then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        grid = thisGrid

        if ONCE.z then
            ONCE.z = false
            print(love.timer.getTime())
            local nextGrid = {}
            for y = 1, cellYCount do
                nextGrid[y] = {}
                for x = 1, cellXCount do
                    local neighborCount = 0

                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dy == 0 and dx == 0)
                            and grid[y + dy]
                            and grid[y + dy][x + dx] then
                                neighborCount = neighborCount + 1
                            end
                        end
                    end

                    nextGrid[y][x] = neighborCount == 3 or (grid[y][x] and neighborCount == 2)
                end
            end
            thisGrid = nextGrid
        end


        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    love.graphics.setColor(colorSelected)
                elseif thisGrid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end

        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, love.mouse.getX(), love.mouse.getY())
    end,
    function()
        drawBackground()
        local grid = {}
        for y = 1, cellYCount do
            grid[y] = {}
            for x = 1, cellXCount do
                grid[y][x] = true
            end
        end

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == 1 and y == 1 then
                    love.graphics.setColor(colorSelected)
                elseif grid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end,
    function()
        drawBackground()
        if not thisGrid then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        local selectedX = math.floor(love.mouse.getX() / cellSize) + 1
        local selectedY = math.floor(love.mouse.getY() / cellSize) + 1

        if love.mouse.isDown(1) then
            thisGrid[selectedY][selectedX] = true
        elseif love.mouse.isDown(2) then
            thisGrid[selectedY][selectedX] = false
        end

        if love.keyboard.isDown('c') then
            thisGrid = {}

            local grid = {}
            for y = 1, cellYCount do
                grid[y] = {}
                for x = 1, cellXCount do
                    grid[y][x] = false
                end
            end
            thisGrid = grid
        end

        grid = thisGrid

        if ONCE.z or ONCE.a then
            ONCE.z = false
            ONCE.a = false
            local nextGrid = {}
            for y = 1, cellYCount do
                nextGrid[y] = {}
                for x = 1, cellXCount do
                    local neighborCount = 0

                    for dy = -1, 1 do
                        for dx = -1, 1 do
                            if not (dy == 0 and dx == 0)
                            and grid[y + dy]
                            and grid[y + dy][x + dx] then
                                neighborCount = neighborCount + 1
                            end
                        end
                    end

                    nextGrid[y][x] = neighborCount == 3 or (grid[y][x] and neighborCount == 2)
                end
            end
            thisGrid = nextGrid
        end


        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if x == selectedX and y == selectedY then
                    love.graphics.setColor(colorSelected)
                elseif thisGrid[y][x] then
                    love.graphics.setColor(colorAlive)
                else
                    love.graphics.setColor(colorDead)
                end
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end

        love.graphics.setColor(255, 255, 100)
        --love.graphics.draw(mouse, love.mouse.getX(), love.mouse.getY())
    end,
}
return t
