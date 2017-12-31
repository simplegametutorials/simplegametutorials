function love.load()
    PLAYER = 'x'
    COMPUTER = 'o'

    colors = {
        background = {218/255, 218/255, 218/255},
        selected = {255/255, 255/255, 193/255},
        square = {255/255, 255/255, 255/255},
        [PLAYER] = {243/255, 81/255, 81/255},
        [COMPUTER] = {79/255, 185/255, 208/255},
    }

    love.graphics.setNewFont(90)

    pad = 10
    side_length = (love.graphics.getWidth() - pad * 4) / 3

    winning_lines = {
        {1, 2, 3},
        {4, 5, 6},
        {7, 8, 9},
        {1, 4, 7},
        {2, 5, 8},
        {3, 6, 9},
        {1, 5, 9},
        {3, 5, 7},
    }

    board = {}
    for i = 1, 9 do
        board[i] = false
    end

    winner = nil

    winning_line = nil

    squares = {}
    for x = 0, 2 do
        for y = 0, 2 do
            table.insert(squares, {
                x = x * side_length + (x + 1) * pad,
                y = y * side_length + (y + 1) * pad,
            })
        end
    end
end

function love.keypressed()
    love.load()
end

function who_won(board)
    for _, line in pairs(winning_lines) do
        if board[line[1]] and board[line[1]] == board[line[2]] and board[line[2]] == board[line[3]] then
            return board[line[1]], line
        end
    end

    for i = 1, 9 do
        if not board[i] then
            return
        end
    end

    return 'draw'
end

function love.mousepressed()
    if selected and not board[selected] then
        board[selected] = PLAYER

        winner, winning_line = who_won(board)
        if winner then return end

        board[computer_move(board, COMPUTER)] = COMPUTER

        winner, winning_line = who_won(board)
        if winner then return end
    end
end

function love.update()
    selected = nil

    if not winner then
        for number, square in pairs(squares) do
            if
            love.mouse.getX() >= square.x and
            love.mouse.getX() <= square.x + side_length and
            love.mouse.getY() >= square.y and
            love.mouse.getY() <= square.y + side_length
            then
                selected = number
            end
        end
    end
end

function love.draw()
    love.graphics.setBackgroundColor(colors.background)

    for number = 1, 9 do

        if number == selected then
            love.graphics.setColor(colors.selected)
        elseif winning_line and (number ~= winning_line[1] and number ~= winning_line[2] and number ~= winning_line[3]) then
            love.graphics.setColor(colors.background)
        else
            love.graphics.setColor(colors.square)
        end

        love.graphics.rectangle('fill', squares[number].x, squares[number].y, side_length, side_length)

        if board[number] then
            love.graphics.setColor(colors[board[number]])
            love.graphics.print(board[number], squares[number].x + 15, squares[number].y - 15)
        end
    end
end

function computer_move(board, turn)
    local other = {
        [PLAYER] = COMPUTER,
        [COMPUTER] = PLAYER,
    }

    local number = {
        [PLAYER] = -1,
        [COMPUTER] = 1,
        draw = 0,
    }

    local f = {
        [PLAYER] = math.min,
        [COMPUTER] = math.max,
    }

    local function minimax(board, turn)
        local winner = who_won(board)
        if winner then
            return number[winner]
        end

        local results = {}
        for i = 1, 9 do
            if not board[i] then
                local copy = {unpack(board)}
                copy[i] = turn
                table.insert(results, minimax(copy, other[turn]))
            end
        end

        return f[turn](unpack(results))
    end

    local results = {}
    for i = 1, 9 do
        if not board[i] then
            local copy = {unpack(board)}
            copy[i] = turn
            table.insert(results, {move = i, score = minimax(copy, other[turn])})
        end
    end

    table.sort(results, function (a, b) return a.score > b.score end)
    return results[1].move
end
