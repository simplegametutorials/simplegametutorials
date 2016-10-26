local t
local playingAreaWidth = 300
local playingAreaHeight = 388
local pipeSpaceHeight = 100
local backgroundColor = {35, 92, 118}
local birdColor = {224, 214, 68}
local pipeColor = {94, 201, 72}
local scoreColor = {255, 255, 255}
local birdX = 62
local birdY = 200
local birdWidth = 30
local birdHeight = 25
local pipeWidth = 54
local scoreX = 15
local scoreY = 15
local font = love.graphics.newFont('SourceCodePro-Regular.ttf')
local function drawArrow2(direction, x, y, length, width, head)
    love.graphics.push()
        love.graphics.translate(x, y)
        love.graphics.push()
            if direction == 'down' then
                love.graphics.rotate(math.pi/2)
            elseif direction == 'left' then
                love.graphics.rotate(math.pi)
                length = length - 1
            elseif direction == 'up' then
                love.graphics.rotate(-math.pi/2)
                length = length - 1
            elseif direction == 'right' then
            end
            love.graphics.translate(0, -width/2)
            love.graphics.rectangle('fill', 0, 0, (length - head / 2), width)
            love.graphics.push()
                love.graphics.translate(length - head / 2, -head / 2 + width / 2)
                local function drawArrowHead(length)
                    local a = math.ceil(length / 2)
                    for i = 1, a do
                        love.graphics.rectangle('fill',
                            (i - 1),
                            (i - 1),
                            1,
                            length - 2 * (i - 1))
                    end
                end
                drawArrowHead(head)
            love.graphics.pop()
        love.graphics.pop()
    love.graphics.pop()
end
local function drawPipe(pipeX, pipeSpaceY)
  love.graphics.setColor(pipeColor)
  love.graphics.rectangle(
      'fill',
      pipeX,
      0,
      pipeWidth,
      pipeSpaceY
  )
  love.graphics.rectangle(
      'fill',
      pipeX,
      pipeSpaceY + pipeSpaceHeight,
      pipeWidth,
      playingAreaHeight - pipeSpaceY - pipeSpaceHeight
  )
end
local function drawBackground()
    love.graphics.setColor(backgroundColor)
    love.graphics.rectangle('fill', 0, 0, playingAreaWidth, playingAreaHeight)
end
local function drawBackgroundAndBird()
    drawBackground()
    love.graphics.setColor(birdColor)
    love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)
end
--[[
local function drawArrow(direction, x, y, length)
    local function pixel(x, y)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, 1, 100)
    love.graphics.translate(-3, -3)
    pixel(1, 3)
    pixel(2, 3)
    pixel(3, 3)
    pixel(4, 3)
    pixel(5, 3)
    pixel(2, 2)
    pixel(3, 2)
    pixel(4, 2)
    pixel(3, 1)
    love.graphics.pop()
end
local function drawUpArrow(x, y, length, text)
    local function pixel(x, y)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 4, 2, length - 4)
    love.graphics.translate(-2, 0)
    pixel(-1, 3)
    pixel(0, 3)
    pixel(1, 3)
    pixel(2, 3)
    pixel(3, 3)
    pixel(4, 3)
    pixel(5, 3)
    pixel(6, 3)

    pixel(0, 2)
    pixel(1, 2)
    pixel(2, 2)
    pixel(3, 2)
    pixel(4, 2)
    pixel(5, 2)

    pixel(1, 1)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)

    pixel(2, 0)
    pixel(3, 0)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x - 105, y + length/2 - height/2, 100, 'right')
end
--]]
local function drawArrow(x, y, length, text)
    local function pixel(x, y)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, 2, length - 4)
    love.graphics.translate(-2, length - 4)
    pixel(-1, 0)
    pixel(0, 0)
    pixel(1, 0)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(5, 0)
    pixel(6, 0)

    pixel(0, 1)
    pixel(1, 1)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    pixel(5, 1)

    pixel(1, 2)
    pixel(2, 2)
    pixel(3, 2)
    pixel(4, 2)

    pixel(2, 3)
    pixel(3, 3)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x - 105, y + length/2 - height/2, 100, 'right')
end
local function drawSpan(x, y, length, text)
    local function pixel(x, y)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, 2, length)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    love.graphics.translate(0, length - 2)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x - 105, y + length/2 - height/2, 100, 'right')
end
local function drawXSpan(x, y, length, text)
    local function pixel(y, x)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, length, 2)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    love.graphics.translate(length - 2, 0)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x, y - height - 5, length, 'center')
end
local function drawRightArrow(x, y, length, text)
    text = text or ''
    local function pixel(y, x)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, length, 2)
    love.graphics.translate(length -4, -2)
    pixel(-1, 0)
    pixel(0, 0)
    pixel(1, 0)
    pixel(2, 0)
    pixel(3, 0)
    pixel(4, 0)
    pixel(5, 0)
    pixel(6, 0)

    pixel(0, 1)
    pixel(1, 1)
    pixel(2, 1)
    pixel(3, 1)
    pixel(4, 1)
    pixel(5, 1)

    pixel(1, 2)
    pixel(2, 2)
    pixel(3, 2)
    pixel(4, 2)

    pixel(2, 3)
    pixel(3, 3)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x, y - height - 5, length, 'center')
end
--[[
local function drawDoubleYArrow(x, y, length, text)
    text = text or ''
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, 2, length)
    function drawPixels(pixel)
        pixel(-1, 0)
        pixel(0, 0)
        pixel(1, 0)
        pixel(2, 0)
        pixel(3, 0)
        pixel(4, 0)
        pixel(5, 0)
        pixel(6, 0)

        pixel(0, 1)
        pixel(1, 1)
        pixel(2, 1)
        pixel(3, 1)
        pixel(4, 1)
        pixel(5, 1)

        pixel(1, 2)
        pixel(2, 2)
        pixel(3, 2)
        pixel(4, 2)

        pixel(2, 3)
        pixel(3, 3)
    end
    local function pixel1(x, y)
        y = -y
        love.graphics.rectangle('fill', x, y+5, 1, 1)
    end
    local function pixel2(x, y)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end

    if length < 0 then
        pixel1, pixel2 = pixel2, pixel1
    end
    love.graphics.translate(-2, -2)
    drawPixels(pixel1)
    love.graphics.translate(0, length - 2)
    drawPixels(pixel2)
    love.graphics.pop()

    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x, y - height - 5, length, 'center')
end
local function drawDoubleXArrow(x, y, length, text)
    text = text or ''
    love.graphics.push()
    love.graphics.translate(x, y)
    love.graphics.rectangle('fill', 0, 0, length, 2)
    love.graphics.translate(length -4, -2)

    function drawPixels(pixel)
        pixel(-1, 0)
        pixel(0, 0)
        pixel(1, 0)
        pixel(2, 0)
        pixel(3, 0)
        pixel(4, 0)
        pixel(5, 0)
        pixel(6, 0)

        pixel(0, 1)
        pixel(1, 1)
        pixel(2, 1)
        pixel(3, 1)
        pixel(4, 1)
        pixel(5, 1)

        pixel(1, 2)
        pixel(2, 2)
        pixel(3, 2)
        pixel(4, 2)

        pixel(2, 3)
        pixel(3, 3)
    end
    local function pixel1(y, x)
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    local function pixel2(y, x)
        x = -x
        love.graphics.rectangle('fill', x, y, 1, 1)
    end
    if length < 0 then
        pixel1, pixel2 = pixel2, pixel1
    end
    drawPixels(pixel1)
    love.graphics.translate(-length + 7, 0)
    drawPixels(pixel2)
    love.graphics.pop()
    local _, count = string.gsub(text, '\n', '')
    local lineHeight = 14
    local height = lineHeight * (count + 1)
    love.graphics.printf(text, x, y - height - 5, length, 'center')
end
--]]
function collide(birdY, pipeX, pipeSpaceY, A, B, C, bottom, D)
    drawBackground()
    love.graphics.setColor(birdColor)
    love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)
    --drawPipe(-25, 90)
    drawPipe(pipeX, pipeSpaceY)
    local function f(a, b, c, n, r)
        love.graphics.setColor(0, 100, 0)
        if r then
            love.graphics.setColor(255, 0, 0)
        end
        local o = 320
        local s = 15
        local y = 0
        love.graphics.printf(a, o - 44, s * (n - 1) + y, 100, 'right')
        love.graphics.print(c, o + 76, s * (n - 1) + y)
    end
    local length = 9
    local function drawArrow3(direction, x, y)
        drawArrow2(direction, x + 10, y, 9, 3, 9)
    end
    local x = 380
    local y = 7
    f('bird left', '<', 'pipe right', 1, A)
    drawArrow3('left', x, y + 15 * 0)
    f('bird right', '<', 'pipe left', 2, B)
    drawArrow3('right', x - length, y + 15 * 1)
    if bottom then
        f('bird bottom', '^', 'pipe top', 3, D)
    else
        f('bird top', '^', 'pipe bottom', 3, C)
    end
    drawArrow3('up', x - 4, 4 + y + 15 * 2)
    if not A and not B and not C and not D then
        love.graphics.setColor(255, 255, 0, 150)
        if not bottom then
            love.graphics.rectangle('fill',
                pipeX, birdY,
                -(pipeX - (birdX + birdWidth)), pipeSpaceY - birdY)
        else
            love.graphics.rectangle('fill',
                pipeX, pipeSpaceY + pipeSpaceHeight,
                -(pipeX - (birdX + birdWidth)), birdY - pipeSpaceY - pipeSpaceHeight + birdHeight)
        end
    end

    local lineColor = {255, 0, 0}
    local fillColor = {255, 0, 0, 100}

    if A then
        local left = pipeX + pipeWidth
        local right = birdX

        love.graphics.setColor(lineColor)
        love.graphics.rectangle('fill',
            left, 0,
            1, playingAreaHeight)
        love.graphics.rectangle('fill',
            right, 0,
            1, playingAreaHeight)

        love.graphics.setColor(fillColor)
        love.graphics.rectangle('fill',
            left,
            0,
            right - left,
            playingAreaHeight
        )
    end

    if B then
        local left = birdX + birdWidth
        local right = pipeX

        love.graphics.setColor(lineColor)
        love.graphics.rectangle('fill',
            left, 0,
            1, playingAreaHeight)
        love.graphics.rectangle('fill',
            right, 0,
            1, playingAreaHeight)

        love.graphics.setColor(fillColor)
        love.graphics.rectangle('fill',
            left,
            0,
            right - left,
            playingAreaHeight
        )
    end

    if C then
        local top = pipeSpaceY
        local bottom = birdY

        love.graphics.setColor(lineColor)
        love.graphics.rectangle('fill',
            0, top,
            playingAreaWidth, 1)
        love.graphics.rectangle('fill',
            0, bottom,
            playingAreaWidth, 1)

        love.graphics.setColor(fillColor)
        love.graphics.rectangle('fill',
            0,
            top,
            playingAreaWidth,
            bottom - top
        )
    end

    if D then
        local top = birdY + birdHeight
        local bottom = pipeSpaceY + pipeSpaceHeight

        love.graphics.setColor(lineColor)
        love.graphics.rectangle('fill',
            0, top,
            playingAreaWidth, 1)
        love.graphics.rectangle('fill',
            0, bottom,
            playingAreaWidth, 1)

        love.graphics.setColor(fillColor)
        love.graphics.rectangle('fill',
            0,
            top,
            playingAreaWidth,
            bottom - top
        )
    end
end
t = {
    function ()
        drawBackground()
        love.graphics.setColor(birdColor)
        love.graphics.rectangle('fill', birdX, 150, birdWidth, birdHeight)
        drawPipe(-25, 90)
        drawPipe(-25+(playingAreaWidth+pipeWidth)/2, 150)
        love.graphics.setColor(scoreColor)
        local score = 7
        love.graphics.print(score, scoreX, scoreY)
    end,
    function ()
        love.graphics.translate(100, 100)
        drawBackground()
        love.graphics.translate(60, 0)
        local pipe1X = 0
        local pipe2X = (playingAreaWidth+pipeWidth)/2
        local pipe1SpaceY = 180
        local pipe2SpaceY = 100

        love.graphics.push()
        drawPipe(pipe1X, pipe1SpaceY)
        love.graphics.translate(-10, 0)
        love.graphics.setColor(255, 255, 255)
        drawSpan(pipe1X, pipe1SpaceY, pipeSpaceHeight, 'pipe\nspace\nheight')
        love.graphics.pop()

        love.graphics.push()
        drawPipe(pipe2X, pipe2SpaceY)
        love.graphics.translate(-10, 0)
        love.graphics.setColor(255, 255, 255)
        drawSpan(pipe2X, pipe2SpaceY, pipeSpaceHeight, 'pipe\nspace\nheight')
        love.graphics.pop()

        love.graphics.setColor(0, 0, 0)
        drawXSpan(pipe1X, -10, pipeWidth, 'pipe\nspace\nwidth')
        drawXSpan(pipe2X, -10, pipeWidth, 'pipe\nspace\nwidth')
    end,
    function ()
        love.graphics.translate(100, 100)
        drawBackground()
        love.graphics.translate(60, 0)
        local pipe1X = 0
        local pipe2X = (playingAreaWidth+pipeWidth)/2
        local pipe1SpaceY = 180
        local pipe2SpaceY = 100

        love.graphics.push()
        drawPipe(pipe1X, pipe1SpaceY)
        love.graphics.translate(-10, 0)
        love.graphics.setColor(255, 255, 255)
        drawArrow(pipe1X, 0, pipe1SpaceY, 'pipe\nspace\nY')
        love.graphics.pop()

        love.graphics.push()
        drawPipe(pipe2X, pipe2SpaceY)
        love.graphics.translate(-10, 0)
        love.graphics.setColor(255, 255, 255)
        drawArrow(pipe2X, 0, pipe2SpaceY, 'pipe\nspace\nY')
        love.graphics.pop()

        love.graphics.setColor(255, 255, 255)
        drawRightArrow(-60, 330, pipe1X + 60, 'pipe X')
        drawRightArrow(-60, 340, pipe2X + 60, '')
        love.graphics.print('pipe X', pipe2X - 50, 321)
    end,
    function ()
        collide(140, -10, 150, true, false, false)
    end,
    function ()
        collide(140, 110, 150, false, true, false)
    end,
    function ()
        collide(165, 90, 150, false, false, true)
    end,
    function ()
        collide(145, 85, 150, false, false, false)
    end,
    function ()
        collide(210, 85, 150, false, false, false, true, true)
    end,
    function ()
        collide(230, 85, 150, false, false, false, true, false)
    end,
    --[[
    function ()
        local function drawPipe(pipeX, pipeSpaceY)
          love.graphics.setColor(pipeColor)
          love.graphics.rectangle(
              'fill',
              pipeX,
              0,
              pipeWidth,
              pipeSpaceY
          )
          --love.graphics.setColor(90, 90, 90)
          love.graphics.rectangle(
              'fill',
              pipeX,
              pipeSpaceY + pipeSpaceHeight,
              pipeWidth,
              playingAreaHeight - pipeSpaceY - pipeSpaceHeight
          )
        end
        local birdY = 100
        local pipeX = 130
        local pipeSpaceY = 150
        local yes = {255, 255, 255}
        local no = {255, 0, 0}
        drawBackground()

        love.graphics.setColor(yes)
        --love.graphics.rectangle('fill', birdX, 0, 1, playingAreaHeight)
        --love.graphics.rectangle('fill', pipeX + pipeWidth, 0, 1, playingAreaHeight)

        love.graphics.setColor(yes)
        --love.graphics.rectangle('fill', birdX + birdWidth, 0, 1, playingAreaHeight)
        --love.graphics.rectangle('fill', pipeX + pipeWidth, 0, 1, playingAreaHeight)

        --love.graphics.setColor(0, 255, 0, 40)
        --love.graphics.rectangle('fill', birdX, 0, pipeX + pipeWidth - birdX, playingAreaHeight)
        
        drawPipe(pipeX, pipeSpaceY)

        love.graphics.setColor(birdColor)
        love.graphics.rectangle('fill', birdX, birdY, birdWidth, birdHeight)
        love.graphics.setColor(yes)
        drawDoubleXArrow(birdX, birdY - 6, pipeX - birdX + pipeWidth)

        love.graphics.setColor(no)
        drawDoubleXArrow(
            birdX + birdWidth,
            birdY + birdHeight/2,
            pipeX - birdX + pipeWidth - birdWidth - pipeWidth
        )

        love.graphics.setColor(yes)
        drawDoubleYArrow(birdX + birdWidth/2, birdY + birdHeight, pipeSpaceY - birdY - birdHeight)
    end,
    --]]
    drawBackground,
    drawBackgroundAndBird,
    function ()
        drawBackground()
        love.graphics.setColor(birdColor)
        love.graphics.rectangle('fill', birdX, birdY+100, birdWidth, birdHeight)
    end,
    function ()
        drawBackgroundAndBird()
        love.graphics.setColor(pipeColor)
        love.graphics.rectangle('fill', playingAreaWidth, 0, pipeWidth, playingAreaHeight)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(playingAreaWidth, 150)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(playingAreaWidth, 8)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(playingAreaWidth, 200)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(200, 200)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(100, 100)
        drawPipe(200, 200)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(100, 140)
        drawPipe(200, 80)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(100-50, 140)
        drawPipe(200-50, 80)
    end,
    function ()
        drawBackgroundAndBird()
        drawPipe(playingAreaWidth, 110)
        drawPipe(playingAreaWidth+(playingAreaWidth+pipeWidth)/2, 150)
    end,
    function ()
        drawBackgroundAndBird()
        score = 0
        drawPipe(-25, 180)
        drawPipe(-25+(playingAreaWidth+pipeWidth)/2, 150)
        love.graphics.setColor(scoreColor)
        love.graphics.print(score, scoreX, scoreY)
    end,
    function ()
        drawBackgroundAndBird()
        score = 34
        drawPipe(-25, 180)
        drawPipe(-25+(playingAreaWidth+pipeWidth)/2, 150)
        love.graphics.setColor(scoreColor)
        love.graphics.print(score, scoreX, scoreY)
    end,
    function ()
        drawBackgroundAndBird()
        score = 1
        drawPipe(-25, 180)
        drawPipe(-25+(playingAreaWidth+pipeWidth)/2, 150)
        love.graphics.setColor(scoreColor)
        love.graphics.print(score, scoreX, scoreY)
    end,
}

return t
