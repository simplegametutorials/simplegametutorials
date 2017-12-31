function love.load()
    boardWidth = 8
    boardHeight = 6
    squareSize = 30

    grid = {}
    for x = 1, boardWidth do
        grid[x] = {}
        for y = 1, boardHeight do
            grid[x][y] = 'empty'
        end
    end

    turn = 1 -- 1, 2
    winningLine = false
end

function love.mousepressed(x, y, input)
    if winningLine == false then
        selectedY = nil
        for y = boardHeight, 1, -1 do
            if grid[selectedX][y] == 'empty' then
                selectedY = y
                break
            end
        end
        if selectedY then
            local other
            if turn == 1 then
                other = 2
            elseif turn == 2 then
                other = 1
            end

            grid[selectedX][selectedY] = turn
            for x = 1, boardWidth do
                for y = 1, boardHeight do
                    if grid[x][y] == turn then
                        for dy = 0, 1 do
                            for dx = 0, 1 do
                                if not (dx == 0 and dy == 0) then
                                    local testX = x
                                    local testY = y
                                    local line = {
                                        {x = testX, y = testY}
                                    }
                                    while true do
                                        testX = testX + dx
                                        testY = testY + dy

                                        if grid[testX] == nil or grid[testX][testY] ~= turn then
                                            break
                                        else
                                            table.insert(line, {x = testX, y = testY})
                                        end
                                        if #line == 4 then
                                            winningLine = line
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end

            turn = other
        end
    else
        love.load()
    end
end

function love.update()
    if winningLine == false then
        selectedX = math.floor(love.mouse.getX() / squareSize) + 1

        if selectedX > boardWidth then
            selectedX = boardWidth
        end

        for y = boardHeight, 1, -1 do
            if grid[selectedX][y] == 'empty' then
                selectedY = y
                break
            end
        end
    end
end

function love.draw()
    for x = 1, boardWidth do
        for y = 1, boardHeight do
            local fade = false
            if winningLine then
                fade = true
                for _, cell in ipairs(winningLine) do
                    if cell.x == x and cell.y == y then
                        fade = false
                    end
                end
            end

            local color
            if fade then
                if grid[x][y] == 1 then
                    color = {0.5, 0.2, 0.2}
                elseif grid[x][y] == 2 then
                    color = {0.2, 0.2, 0.5}
                else
                    color = {0.9, 0.9, 0.9}
                end
            else
                if grid[x][y] == 1 then
                    color = {1, 0.1, 0.1}
                elseif grid[x][y] == 2 then
                    color = {0.1, 0.1, 1}
                elseif selectedX == x and selectedY == y then
                    color = {0.1, 1, 0.1}
                else
                    color = {0.9, 0.9, 0.9}
                end
            end

            love.graphics.setColor(color)
            love.graphics.rectangle(
                'fill',
                (x - 1) * squareSize,
                (y - 1) * squareSize,
                squareSize - 1,
                squareSize - 1)
        end
    end
end
