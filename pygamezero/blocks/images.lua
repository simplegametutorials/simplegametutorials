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

love.graphics.setNewFont('SourceCodePro-Regular.ttf', 12)
local gridYCount = 18
local gridXCount = 10
local colors = {
    [' '] = {220, 220, 220},
    i = {120, 195, 239},
    j = {236, 231, 108},
    l = {124, 218, 193},
    o = {234, 177, 121},
    s = {211, 136, 236},
    t = {248, 147, 196},
    z = {169, 221, 118},
    preview = {190, 190, 190},
    background = {255, 255, 255},
}

local pieceStructures = {
    {
        {
            {' ', ' ', ' ', ' '},
            {'i', 'i', 'i', 'i'},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
            {' ', 'i', ' ', ' '},
        },
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 'o', 'o', ' '},
            {' ', 'o', 'o', ' '},
            {' ', ' ', ' ', ' '},
        }
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', 'j', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {'j', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'j', ' ', ' ', ' '},
            {'j', 'j', 'j', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'j', 'j', ' '},
            {' ', 'j', ' ', ' '},
            {' ', 'j', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'l', 'l', 'l', ' '},
            {'l', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', ' ', 'l', ' '},
            {'l', 'l', 'l', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {'l', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', 'l', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {' ', 't', 't', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', 't', ' '},
            {' ', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        },
        {
            {' ', 't', ' ', ' '},
            {'t', 't', ' ', ' '},
            {' ', 't', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {' ', 's', 's', ' '},
            {'s', 's', ' ', ' '},
            {' ', ' ', ' ', ' '}
        },
        {
            {'s', ' ', ' ', ' '},
            {'s', 's', ' ', ' '},
            {' ', 's', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }
    },
    {
        {
            {' ', ' ', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {' ', 'z', 'z', ' '},
            {' ', ' ', ' ', ' '}
        },
        {
            {' ', 'z', ' ', ' '},
            {'z', 'z', ' ', ' '},
            {'z', ' ', ' ', ' '},
            {' ', ' ', ' ', ' '},
        }
    }
}

local blockSize = 20

local function drawBlock(x, y, color)
    love.graphics.setColor(color)
    local blockDrawSize = blockSize - 1
    love.graphics.rectangle(
    'fill',
    (x - 1) * blockSize,
    (y - 1) * blockSize,
    blockDrawSize,
    blockDrawSize
    )
end

local function drawPiece(pieceType, pieceRotation, offsetX, offsetY, isPreview)
    local pieceXCount = 4
    local pieceYCount = 4
    for y = 1, pieceXCount do
        for x = 1, pieceYCount do
            local block = pieceStructures[pieceType][pieceRotation][y][x]
            if block ~= ' ' then
                local color
                if isPreview then
                    color = colors.preview
                else
                    color = colors[block]
                end
                drawBlock(x + offsetX, y + offsetY, color)
            end
        end
    end
end

local screenshotState={pieceY=3,inert={{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" "," "," "," "," "," "," "," "," "," "},{" ","j"," ","z","z"," "," "," "," "," "},{" ","j","o","o","z","z"," ","s"," "," "},{"o","o","s","s","z","z","i","t","s"," "},{"t","z","z","s","j","j","i","t","t"," "},{"s","l","j","j"," ","z","s","o","o","l"},{"s","s","j","l","z","z"," ","o","o","i"},{"t","s","j","l","z","j"," ","o","o","i"},{"t","t","i","l","l","j"," ","s"," ","i"},{" ","t","i"," "," "," ","j","s","s","i"},{"t","t","t","l","l","l","j","s"," ","i"},{"i","j"," ","z","o","o","t","l","l","l"}},pieceX=8,pieceRotation=2}

local function drawTable(t)
    love.graphics.push('all')
    local blockSize = 20
    local blockDrawSize = blockSize - 1
    local moveSize = blockSize + 10
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('[', 0, 0)
    love.graphics.translate(10, 0)
    for x = 1, #t do
        local color = colors[t[x]]
        love.graphics.setColor(color)
        love.graphics.rectangle(
            'fill',
            (x - 1) * moveSize,
            0,
            blockDrawSize,
            blockDrawSize
        )
        love.graphics.setColor(0, 0, 0)
        local function f(s)
            love.graphics.print(
            s,
            (x - 1) * moveSize - 2,
            1
            )
        end
        f("'"..t[x].."'")
        if x ~= #t then
            f('   ,')
        end
    end
    love.graphics.print('],', #t * moveSize - 8, 0)
    love.graphics.pop()
end

local function drawTable2(t)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('[', 0, 0)

    love.graphics.push('all')
    love.graphics.translate(20, 20)
    for y = 1, #t do
        drawTable(t[y])
        love.graphics.translate(0, 30)
    end
    love.graphics.pop()

    love.graphics.print('],', 0, #t * 30 + 10)
end

local function drawTable3(t)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('[', 0, 0)

    --love.graphics.push('all')
    love.graphics.translate(20, 20)
    for y = 1, #t do
        drawTable2(t[y])
        love.graphics.translate(0, (#t[y] + 1) * 30)
    end
    love.graphics.print('],', -20, 0)
    love.graphics.translate(-20, 20)
    --love.graphics.pop()
end

local function drawTable4(t)
    love.graphics.setColor(0, 0, 0)
    love.graphics.print('[', 0, 0)
    love.graphics.translate(20, 20)

    love.graphics.push('all')
    for y = 1, #t do
        drawTable3(t[y])
        --love.graphics.translate(0, (#t[y] + 1) * 30)
    end
    love.graphics.print(']', -20, 0)
    love.graphics.pop()
end

local function drawGrid(inert, gridXCount, gridYCount)
    local realBlockSize = blockSize
    local blockSize = 30
    local blockDrawSize = realBlockSize - 1

    love.graphics.setColor(0, 0, 0)
    love.graphics.print('[', 0, 0)

    love.graphics.translate(24, 18)



    for y = 1, gridYCount do
        for x = 1, gridXCount do
            local drawX = x
            local drawY = y

        end
    end


    for y = 1, gridYCount do
        love.graphics.print('[', -10, (y - 1) * blockSize)
        for x = 1, gridXCount do
        end
        love.graphics.print("],", gridXCount * blockSize - 1, (y - 1) * blockSize)
    end
end

local offsetY = 5
local offsetX = 2

local function drawBackground()
    love.graphics.push('all')
    love.graphics.setColor(colors.background)
    love.graphics.rectangle(
    'fill',
    0, 0,
    blockSize * (offsetX+2 + gridXCount),
    blockSize * (offsetY+2 + gridYCount)
    )
    love.graphics.pop()
end

local function drawSmallBackground()
    love.graphics.push('all')
    love.graphics.setColor(colors.background)
    love.graphics.rectangle(
    'fill',
    0, 0,
    blockSize * gridXCount,
    blockSize * gridYCount
    )
    love.graphics.pop()
end

local function createInert()
    local inert = {}
    for y = 1, 18 do
        inert[y] = {}
        for x = 1, 10 do
            inert[y][x] = ' '
        end
    end
    return inert
end

return {
    function()
        drawBackground()

        drawPiece(6, 1, 5, 1, true)

        local inert = screenshotState.inert
        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x + offsetX, y + offsetY, color)
            end
        end

        drawPiece(1, 2, 10, 7)
    end,
    function()
        for pieceType = 1, #pieceStructures do
            drawPiece(pieceType, 1, 4 * (pieceType - 1), 0)
        end
    end,
    function()
        drawPiece(6, 1, 0, 0, true)
    end,
    function()
        drawTable2(screenshotState.inert)
    end,
    function()
        drawTable4(pieceStructures)
    end,

    function()
        drawSmallBackground()
        for y = 1, 18 do
            for x = 1, 10 do
                love.graphics.setColor(colors[' '])
                love.graphics.rectangle(
                    'fill',
                    (x - 1) * 20,
                    (y - 1) * 20,
                    19,
                    19
                )
            end
        end
    end,

    function()
        drawSmallBackground()

        local inert = createInert()
        inert[18][1] = 'i'
        inert[17][2] = 'j'
        inert[16][3] = 'l'
        inert[15][4] = 'o'
        inert[14][5] = 's'
        inert[13][6] = 't'
        inert[12][7] = 'z'

        for y = 1, 18 do
            for x = 1, 10 do
                local color
                if inert[y][x] == ' ' then
                    color = {222, 222, 222}
                elseif inert[y][x] == 'i' then
                    color = {120, 195, 239}
                elseif inert[y][x] == 'j' then
                    color = {236, 231, 108}
                elseif inert[y][x] == 'l' then
                    color = {124, 218, 193}
                elseif inert[y][x] == 'o' then
                    color = {234, 177, 121}
                elseif inert[y][x] == 's' then
                    color = {211, 136, 236}
                elseif inert[y][x] == 't' then
                    color = {248, 147, 196}
                elseif inert[y][x] == 'z' then
                    color = {169, 221, 118}
                end
                love.graphics.setColor(color)
                    
                local blockSize = 20
                local blockDrawSize = blockSize - 1
                love.graphics.rectangle(
                    'fill',
                    (x - 1) * blockSize,
                    (y - 1) * blockSize,
                    blockDrawSize,
                    blockDrawSize
                )
            end
        end
    end,

    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x, y, color)
                end
            end
        end
    end,

    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 2
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x, y, color)
                end
            end
        end
    end,
    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 7
        local pieceRotation = 2
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x, y, color)
                end
            end
        end
    end,
    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 3
        local pieceY = 0
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX, y + pieceY, colors[block])
                end
            end
        end
    end,
    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 5
        local pieceY = 0
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX, y + pieceY, colors[block])
                end
            end
        end
    end,
    function()
        drawSmallBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 3
        local pieceY = 5
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX, y + pieceY, colors[block])
                end
            end
        end
    end,
    function()
        drawSmallBackground()
        local inert = createInert()
        inert[8][5] = 'z'
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 3
        local pieceY = 5
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x, y, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX, y + pieceY, colors[block])
                end
            end
        end
    end,
    function()
        drawBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 3
        local pieceY = 0
        local offsetX = 2
        local offsetY = 5
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
            preview = {190, 190, 190},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x + offsetX, y + offsetY, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX + offsetX, y + pieceY + offsetY, colors[block])
                end
            end
        end

        for y = 1, pieceY do
            for x = 1, pieceX do
                local block = pieceStructures[sequence[#sequence]][1][y][x]
                if block ~= ' ' then
                    drawBlock('preview', x + 5, y + 1)
                end
            end
        end
    end,
    function()
        drawBackground()
        local inert = createInert()
        local pieceType = 1
        local pieceRotation = 1
        local pieceX = 3
        local pieceY = 0
        local offsetX = 2
        local offsetY = 5
        local function drawBlock(x, y, color)
            love.graphics.setColor(color)

            local blockSize = 20
            local blockDrawSize = blockSize - 1
            love.graphics.rectangle(
            'fill',
            (x - 1) * blockSize,
            (y - 1) * blockSize,
            blockDrawSize,
            blockDrawSize
            )
        end

        local colors = {
            [' '] = {222, 222, 222},
            i = {120, 195, 239},
            j = {236, 231, 108},
            l = {124, 218, 193},
            o = {234, 177, 121},
            s = {211, 136, 236},
            t = {248, 147, 196},
            z = {169, 221, 118},
            preview = {190, 190, 190},
        }

        for y = 1, gridYCount do
            for x = 1, gridXCount do
                local block = inert[y][x]
                local color = colors[block]
                drawBlock(x + offsetX, y + offsetY, color)
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[pieceType][pieceRotation][y][x]
                if block ~= ' ' then
                    local color =  colors[block]
                    drawBlock(x + pieceX + offsetX, y + pieceY + offsetY, colors[block])
                end
            end
        end

        for y = 1, 4 do
            for x = 1, 4 do
                local block = pieceStructures[6][1][y][x]
                if block ~= ' ' then
                    local color =  colors.preview
                    drawBlock(x + 5, y + 1, color)
                end
            end
        end
    end,
}

