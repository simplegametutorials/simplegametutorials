love._openConsole()
local function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end
local images = {}
for _, image in ipairs({
    1, 2, 3, 4, 5, 6, 7, 8,
    'uncovered', 'covered_highlighted', 'covered', 'flower', 'flag', 'question',
}) do
    images[image] = love.graphics.newImage('flowers/images/'..image..'.png')
end
local cellXCount = 19
local cellYCount = 14
local cellSize = 18
local gridXCount = cellXCount
local gridYCount = cellYCount
local mouse = love.graphics.newImage('mouse.png')

local function drawCell(image, x, y)
    love.graphics.draw(image, (x - 1) * cellSize, (y - 1) * cellSize)
end

local function uncover(grid, selectedX, selectedY)
    local stack = {
        {
            x = selectedX,
            y = selectedY,
        }
    }

    while #stack > 0 do
        local current = table.remove(stack)
        local x = current.x
        local y = current.y

        grid[y][x].state = 'uncovered'
        
        if getSurroundingFlowerCount(grid, x, y) == 0 then
            for dy = -1, 1 do
                for dx = -1, 1 do
                    if not (dx == 0 and dy == 0)
                        and grid[y + dy]
                        and grid[y + dy][x + dx]
                        and grid[y + dy][x + dx].state == 'covered' then
                        table.insert(
                            stack, {
                                x = x + dx,
                                y = y + dy
                            }
                        )
                    end
                end
            end
        end
    end
end

function getSurroundingFlowerCount(grid, x, y)
    local surroundingCount = 0

    for dy = -1, 1 do
        for dx = -1, 1 do
            if not (dy == 0 and dx == 0)
            and grid[y + dy]
            and grid[y + dy][x + dx]
            and grid[y + dy][x + dx].flower
            then
                surroundingCount = surroundingCount + 1
            end
        end
    end

    return surroundingCount
end

if ONCE.start or ONCE.z then
    local possibleFlowerPositions = {}
    for y = 1, gridYCount do
        for x = 1, gridXCount do
            table.insert(possibleFlowerPositions, {x = x, y = y})
        end
    end
    ONCE.z = false
    grid = {}
    for y = 1, gridYCount do
        grid[y] = {}
        for x = 1, gridXCount do
            grid[y][x] = {
                flower = false,
                state = 'covered',
            }
        end
    end

    for flowerIndex = 1, 30 do
        local position = table.remove(possibleFlowerPositions, love.math.random(#possibleFlowerPositions))
        grid[position.y][position.x].flower = true
    end
end

ONCE.start = false

function eachCell(f)
    for y = 1, cellYCount do
        for x = 1, cellXCount do
            f(x, y)
        end
    end
end

function falseGrid()
    local grid = {}
    for y = 1, cellYCount do
        grid[y] = {}
        for x = 1, cellXCount do
            grid[y][x] = {
                flower = false,
                state = 'covered',
            }
        end
    end
    return grid
end

local t
t = {
    function()
        local mouseX = 260
        local mouseY = 151
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        oldGrid = grid
        grid = deepcopy(oldGrid)

        uncover(grid, selectedX, selectedY)

        grid[2][4].state = 'flag'
        grid[10][9].state = 'flag'
        grid[12][12].state = 'flag'

        grid[5][17].state = 'flag'
        grid[5][18].state = 'flag'
        grid[4][19].state = 'flag'
        grid[3][13].state = 'flag'

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                if grid[y][x].flower then
                    --love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 and grid[y][x].state == 'uncovered' then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end

                if grid[y][x].state == 'flag' then
                    drawCell(images.flag, x, y)
                elseif grid[y][x].state == 'question' then
                    drawCell(images.question, x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        --love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
    function()
        love.graphics.setColor(130, 130, 130)
        love.graphics.rectangle('fill', 0, 0, 18*8+2, 18*2+2)
        love.graphics.setColor(255, 255, 255)

        local move = 18
        love.graphics.translate(1, 1)
        love.graphics.draw(images.covered)
        love.graphics.translate(move, 0)
        love.graphics.draw(images.covered_highlighted)
        love.graphics.translate(move, 0)
        love.graphics.draw(images.uncovered)
        love.graphics.translate(move, 0)
        love.graphics.draw(images.flower)
        love.graphics.translate(move, 0)
        love.graphics.draw(images.flag)
        love.graphics.translate(move, 0)
        love.graphics.draw(images.question)
        love.graphics.origin()
        love.graphics.translate(0, 20)
        love.graphics.draw(images[1])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[2])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[3])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[4])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[5])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[6])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[7])
        love.graphics.translate(move, 0)
        love.graphics.draw(images[8])
    end,
    function()
        eachCell(function(x, y)
            drawCell(images.covered, x, y)
        end)
    end,
    function()
        eachCell(function(x, y)
            drawCell(images.covered, x, y)
        end)

        local mouseX = 210
        local mouseY = 135
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        love.graphics.setColor(0, 0, 0)
        love.graphics.print('selected x: '..selectedX..' selected y: '..selectedY)
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
    end,
    function()
        eachCell(function(x, y)
            drawCell(images.covered, x, y)
        end)

        local mouseX = 390
        local mouseY = 135
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        
        if selectedX > gridXCount then
            selectedX = gridXCount
        end
        if selectedY > gridYCount then
            selectedY = gridYCount
        end

        love.graphics.setColor(0, 0, 0)
        love.graphics.print('selected x: '..selectedX..' selected y: '..selectedY)
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
    end,

    function()
        local mouseX = 210
        local mouseY = 135
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        local grid = falseGrid()

        eachCell(function(x, y)
            if x == selectedX and y == selectedY then
                drawCell(images.covered_highlighted, x, y)
            else
                drawCell(images.covered, x, y)
            end

            if grid[y][x].flower then
                drawCell(images.flower, x, y)
            elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
            end
        end)

        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
    end,


    function()
        local mouseX = 210
        local mouseY = 135
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        local grid = falseGrid()
        eachCell(function(x, y)
            if x == selectedX and y == selectedY then
                drawCell(images.uncovered, x, y)
            else
                drawCell(images.covered, x, y)
            end
            if grid[y][x].flower then
                drawCell(images.flower, x, y)
            elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
            end
        end)
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
    end,

    function()
        local grid = falseGrid()
        grid[1][1].flower = true
        grid[1][2].flower = true

        eachCell(function(x, y)
            drawCell(images.covered, x, y)
            if x == 1 and y == 1 then
                drawCell(images.covered_highlighted, x, y)
            end
            if grid[y][x].flower then
                drawCell(images.flower, x, y)
            end
        end)

    end,
    function()
        local mouseX = 210
        local mouseY = 135
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        local grid = falseGrid()
        grid[1][1].flower = true
        grid[1][2].flower = true
        grid[1][3].flower = true
        grid[1][5].flower = true
        grid[2][1].flower = true
        grid[2][3].flower = true
        grid[2][4].flower = true
        grid[2][5].flower = true
        grid[3][1].flower = true
        grid[3][2].flower = true
        grid[3][3].flower = true
        grid[3][5].flower = true
        grid[4][3].flower = true
        grid[4][4].flower = true
        grid[5][1].flower = true
        grid[5][2].flower = true
        eachCell(function(x, y)
            drawCell(images.covered, x, y)
            if x == 1 and y == 1 then
                drawCell(images.covered_highlighted, x, y)
            end
            if grid[y][x].flower then
                drawCell(images.flower, x, y)
            elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
            end
        end)
        love.graphics.setColor(255, 255, 100)
    end,
    function()
        eachCell(function(x, y)
            love.graphics.draw(images.covered, (x - 1) * cellSize, (y - 1) * cellSize)
            if x == 1 and y == 1 then
                love.graphics.draw(images.covered_highlighted, (x - 1) * cellSize, (y - 1) * cellSize)
            end
            if grid[y][x].flower then
                love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
            elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
            end
        end)
    end,
    function()
        local mouseX = 260
        local mouseY = 151
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        oldGrid = grid
        grid = deepcopy(oldGrid)
        grid[6][7].state = 'uncovered'
        grid[12][10].state = 'uncovered'
        grid[10][3].state = 'uncovered'
        grid[selectedY][selectedX].state = 'uncovered'
        eachCell(function(x, y)
            if grid[y][x].state == 'uncovered' then
                drawCell(images.uncovered, x, y)
            elseif x == selectedX and y == selectedY then
                drawCell(images.covered_highlighted, x, y)
            else
                drawCell(images.covered, x, y)
            end

            -- etc.
            if grid[y][x].flower then
                love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
            elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
            end
        end)
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
        grid[6][7].state = 'covered'
        grid[12][10].state = 'covered'
        grid[10][3].state = 'covered'
        grid = oldGrid
    end,
    function()
        local mouseX = 260
        local mouseY = 151
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        --local grid = {}
        --for y = 1, cellYCount do
            --grid[y] = {}
            --for x = 1, cellXCount do
                --grid[y][x] = {
                    --flower = false,
                    --state = 'covered',
                --}
            --end
        --end
        oldGrid = grid
        grid = deepcopy(oldGrid)
        for y = 1, cellYCount do
            for x = 1, cellXCount do
                grid[y][x].state = 'uncovered'
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                -- etc.
                if grid[y][x].flower then
                    love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
    function()
        local mouseX = 260
        local mouseY = 151
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1
        --local grid = {}
        --for y = 1, cellYCount do
            --grid[y] = {}
            --for x = 1, cellXCount do
                --grid[y][x] = {
                    --flower = false,
                    --state = 'covered',
                --}
            --end
        --end
        oldGrid = grid
        grid = deepcopy(oldGrid)

        local stack = {
            {
                x = selectedX,
                y = selectedY,
            }
        }

        while #stack > 0 do
            local current = table.remove(stack)
            local x = current.x
            local y = current.y

            grid[y][x].state = 'uncovered'
            
            if getSurroundingFlowerCount(grid, x, y) == 0 then
                for dy = -1, 1 do
                    for dx = -1, 1 do
                        if not (dx == 0 and dy == 0)
                            and grid[y + dy]
                            and grid[y + dy][x + dx]
                            and grid[y + dy][x + dx].state == 'covered' then
                            table.insert(
                                stack, {
                                    x = x + dx,
                                    y = y + dy
                                }
                            )
                        else
                            if not (dx == 0 and dy == 0)
                                and grid[y + dy]
                                and grid[y + dy][x + dx]
                            then
                                print( grid[y + dy][x + dx].state)
                            end
                        end
                    end
                end
            end
        end

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                --grid[y][x].state = 'uncovered'
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                -- etc.
                if grid[y][x].flower then
                    love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
    function()
        local mouseX = 1
        local mouseY = 1
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        oldGrid = grid
        grid = deepcopy(oldGrid)

        
        grid[1][1].state = 'flag'
        grid[1][2].state = 'question'

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                --grid[y][x].state = 'uncovered'
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                -- etc.
                if grid[y][x].flower then
                    love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end

                if grid[y][x].state == 'flag' then
                    drawCell(images.flag, x, y)
                elseif grid[y][x].state == 'question' then
                    drawCell(images.question, x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        --love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
    function()
        local mouseX = 1
        local mouseY = 1
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        oldGrid = grid
        grid = deepcopy(oldGrid)

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                if grid[y][x].flower then
                    --love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end

                if grid[y][x].state == 'flag' then
                    drawCell(images.flag, x, y)
                elseif grid[y][x].state == 'question' then
                    drawCell(images.question, x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        --love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
    function()
        local mouseX = 260
        local mouseY = 151
        local selectedX = math.floor(mouseX / cellSize) + 1
        local selectedY = math.floor(mouseY / cellSize) + 1

        oldGrid = grid
        grid = deepcopy(oldGrid)

        uncover(grid, selectedX, selectedY)

        for y = 1, cellYCount do
            for x = 1, cellXCount do
                if grid[y][x].state == 'uncovered' then
                    drawCell(images.uncovered, x, y)
                elseif x == selectedX and y == selectedY then
                    drawCell(images.covered_highlighted, x, y)
                else
                    drawCell(images.covered, x, y)
                end

                if grid[y][x].flower then
                    --love.graphics.draw(images.flower, (x - 1) * cellSize, (y - 1) * cellSize)
                elseif getSurroundingFlowerCount(grid, x, y) > 0 and grid[y][x].state == 'uncovered' then
                    drawCell(images[getSurroundingFlowerCount(grid, x, y)], x, y)
                end

                if grid[y][x].state == 'flag' then
                    drawCell(images.flag, x, y)
                elseif grid[y][x].state == 'question' then
                    drawCell(images.question, x, y)
                end
            end
        end
        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, mouseX, mouseY)
        grid = oldGrid
    end,
}

return t
