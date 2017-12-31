function love.load()
    function createFlipGrid()
        flipGrid = {}

        local changes = {
            {x = 1, y = 0},
            {x = -1, y = 0},
            {x = 0, y = -1},
            {x = 0, y = 1},
            {x = 1, y = 1},
            {x = 1, y = -1},
            {x = -1, y = 1},
            {x = -1, y = -1},
        }
        for x = 1, boardSize do
            flipGrid[x] = {}
            for y = 1, boardSize do
                flipGrid[x][y] = {}
                if grid[x][y] == 'empty' then
                    for i = 1, #changes do
                        local testX = x + changes[i].x
                        local testY = y + changes[i].y

                        local potentiallyFlipped = {}

                        while
                        grid[testX] ~= nil and
                        grid[testX][testY] ~= nil and
                        grid[testX][testY] ~= 'empty'
                        do
                            if grid[testX][testY] == other[turn] then
                                table.insert(potentiallyFlipped, {
                                    x = testX,
                                    y = testY
                                })
                            elseif grid[testX][testY] == turn then
                                for i = 1, #potentiallyFlipped do
                                    table.insert(flipGrid[x][y], {
                                        x = potentiallyFlipped[i].x,
                                        y = potentiallyFlipped[i].y
                                    })
                                end
                                break
                            end
                            
                            testX = testX + changes[i].x
                            testY = testY + changes[i].y
                        end
                    end
                end
            end
        end
    end
    squareSize = 30

    boardSize = 8
    other = {
        dark = 'light',
        light = 'dark',
    }

    grid = {}
    for x = 1, boardSize do
        grid[x] = {}
        for y = 1, boardSize do
            grid[x][y] = 'empty'
        end
    end
    grid[4][5] = 'dark'
    grid[5][4] = 'dark'
    grid[4][4] = 'light'
    grid[5][5] = 'light'
    turn = 'dark'
    createFlipGrid()

    selectedX = 1
    selectedY = 1
end

function love.mousepressed()
    local toFlip = flipGrid[selectedX][selectedY]
    if #toFlip > 0 then
        grid[selectedX][selectedY] = turn
        for i = 1, #toFlip do
            grid[toFlip[i].x][toFlip[i].y] = turn
        end

        turn = other[turn]
        createFlipGrid()

        local totalDark = 0
        local totalLight = 0
        for x = 1, boardSize do
            for y = 1, boardSize do
                if grid[x][y] == 'dark' then
                    totalDark = totalDark + 1
                elseif grid[x][y] == 'light' then
                    totalLight = totalLight + 1
                end
            end
        end

        print('dark: '..totalDark..' light: '..totalLight)

        local possibleToMove = false
        for x = 1, boardSize do
            for y = 1, boardSize do
                if #flipGrid[x][y] > 0 then
                    possibleToMove = true
                end
            end
        end

        if not possibleToMove then
            turn = other[turn]
            createFlipGrid()
            for x = 1, boardSize do
                for y = 1, boardSize do
                    if #flipGrid[x][y] > 0 then
                        possibleToMove = true
                    end
                end
            end
        end

        if possibleToMove then
            print('turn: '..turn)
        else
            print('game over')
            if totalLight < totalDark then
                print('dark wins')
            elseif totalLight > totalDark then
                print('light wins')
            else
                print('draw')
            end
        end
    end
end

function love.update()
    selectedX = math.floor(love.mouse.getX() / squareSize) + 1
    selectedY = math.floor(love.mouse.getY() / squareSize) + 1
end

function love.draw()
    local function drawSquare(x, y, color)
        love.graphics.setColor(color)
        love.graphics.rectangle(
            'fill',
            (x - 1) * squareSize,
            (y - 1) * squareSize,
            squareSize - 1,
            squareSize - 1)
    end

    for x = 1, boardSize do
        for y = 1, boardSize do
            local color
            if grid[x][y] == 'light' then
                color = {.8, .8, .8}
            elseif grid[x][y] == 'dark' then
                color = {.2, .2, .2}
            elseif #flipGrid[x][y] > 0 then
                color = {.5, .7, .5}
            else
                color = {.2, .4, .2}
            end
            drawSquare(x, y, color)
        end
    end

    drawSquare(selectedX, selectedY, {1, 1, 1, .4})
end
