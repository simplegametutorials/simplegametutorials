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

mouse = love.graphics.newImage('mouse.png')
font = love.graphics.newFont('SourceCodePro-Regular.ttf', 15)
images = {}
for nameIndex, name in ipairs({
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
    'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
    'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
    'card', 'card_face_down',
    'face_jack', 'face_queen', 'face_king',
}) do
    images[name] = love.graphics.newImage('love/blackjack/images/'..name..'.png')
end
function getTotal(hand)
    local total = 0
    local hasAce = false
    for cardIndex, card in ipairs(hand) do
        if card.rank > 10 then
            total = total + 10
        else
            total = total + card.rank
        end
        
        if card.rank == 1 then
            hasAce = true
        end
    end

    if hasAce and total <= 11 then
        total = total + 10
    end
        
    return total
end

function drawCard(card, x, y)
    love.graphics.setColor(255, 255, 255)
    love.graphics.draw(images.card, x, y)

    if card.suit == 'heart' or card.suit == 'diamond' then
        love.graphics.setColor(228, 15, 100)
    else
        love.graphics.setColor(50, 50, 50)
    end

    local cardWidth = 53
    local cardHeight = 73
    local numberOffsetX = 3
    local numberOffsetY = 4
    love.graphics.draw(
        images[card.rank],
        x + numberOffsetX,
        y + numberOffsetY
    )
    love.graphics.draw(
        images[card.rank],
        x + cardWidth - numberOffsetX,
        y + cardHeight - numberOffsetY,
        0,
        -1
    )

    local suitOffsetX = 3
    local suitOffsetY = 14
    local suitImage = images['mini_'..card.suit]
    love.graphics.draw(
        suitImage,
        x + suitOffsetX,
        y + suitOffsetY
    )
    love.graphics.draw(
        suitImage,
        x + cardWidth - suitOffsetX,
        y + cardHeight - suitOffsetY,
        0,
        -1
    )

    if card.rank > 10 then
        local faceImage
        if card.rank == 11 then
            faceImage = images.face_jack
        elseif card.rank == 12 then
            faceImage = images.face_queen
        elseif card.rank == 13 then
            faceImage = images.face_king
        end
        love.graphics.setColor(255, 255, 255)
        love.graphics.draw(faceImage, x + 12, y + 11)
    else
        local function drawPip(offsetX, offsetY, mirrorX, mirrorY)
            local pipImage = images['pip_'..card.suit]
            local pipWidth = 11
            love.graphics.draw(
                pipImage,
                x + offsetX,
                y + offsetY
            )
            if mirrorX then
                love.graphics.draw(
                    pipImage,
                    x + cardWidth - offsetX - pipWidth,
                    y + offsetY
                )
            end
            if mirrorY then
                love.graphics.draw(
                    pipImage,
                    x + offsetX + pipWidth,
                    y + cardHeight - offsetY,
                    0,
                    -1
                )
            end
            if mirrorX and mirrorY then
                love.graphics.draw(
                    pipImage,
                    x + cardWidth - offsetX,
                    y + cardHeight - offsetY,
                    0,
                    -1
                )
            end
        end

        local p = {
            xMid = 21,
            xLeft = 11,
            yTop = 7,
            yMid = 31,
            yThird = 19,
            y23 = 23
        }

        if card.rank == 1 then
            drawPip(p.xMid, p.yMid)
        elseif card.rank == 2 then
            drawPip(p.xMid, p.yTop, false, true)
        elseif card.rank == 3 then
            drawPip(p.xMid, p.yTop, false, true)
            drawPip(p.xMid, p.yMid)
        elseif card.rank == 4 then
            drawPip(p.xLeft, p.yTop, true, true)
        elseif card.rank == 5 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xMid, p.yMid)
        elseif card.rank == 6 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xLeft, p.yMid, true)
        elseif card.rank == 7 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xLeft, p.yMid, true)
            drawPip(p.xMid, p.yThird)
        elseif card.rank == 8 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xLeft, p.yMid, true)
            drawPip(p.xMid, p.yThird, false, true)
        elseif card.rank == 9 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xLeft, p.y23, true, true)
            drawPip(p.xMid, p.yMid)
        elseif card.rank == 10 then
            drawPip(p.xLeft, p.yTop, true, true)
            drawPip(p.xLeft, p.y23, true, true)
            drawPip(p.xMid, 16, false, true)
        end
    end
end

dealerMarginY = 30

playerHand = {
    {
        suit = 'heart',
        rank = 1,
    },
    {
        suit = 'spade',
        rank = 12,
    },
}
playerHand1 = {
    {
        suit = 'heart',
        rank = 1,
    },
    {
        suit = 'spade',
        rank = 12,
    },
}
playerHand1b = {
    {
        suit = 'heart',
        rank = 1,
    },
    {
        suit = 'spade',
        rank = 12,
    },
    {
        suit = 'club',
        rank = 7,
    },
}
playerHand2 = {
    {
        suit = 'diamond',
        rank = 2,
    },
    {
        suit = 'heart',
        rank = 11,
    },
    {
        suit = 'club',
        rank = 7,
    },
}
playerHand3 = {
    {
        suit = 'heart',
        rank = 1,
    },
    {
        suit = 'spade',
        rank = 12,
    },
    {
        suit = 'club',
        rank = 7,
    },
    {
        suit = 'club',
        rank = 9,
    },
}
dealerHand = {
    {
        suit = 'spade',
        rank = 1,
    },
    {
        suit = 'diamond',
        rank = 1,
    },
}
dealerHand1 = {
    {
        suit = 'spade',
        rank = 1,
    },
    {
        suit = 'diamond',
        rank = 1,
    },
}
dealerHand2 = {
    {
        suit = 'spade',
        rank = 1,
    },
    {
        suit = 'diamond',
        rank = 1,
    },
    {
        suit = 'spade',
        rank = 2,
    },
    {
        suit = 'heart',
        rank = 7,
    },
}
testHand1 = {
    {suit = 'club', rank = 1},
    {suit = 'diamond', rank = 2},
    {suit = 'heart', rank = 3},
    {suit = 'spade', rank = 4},
    {suit = 'club', rank = 5},
    {suit = 'diamond', rank = 6},
    {suit = 'heart', rank = 7},
}
testHand2 = {
    {suit = 'spade', rank = 8},
    {suit = 'club', rank = 9},
    {suit = 'diamond', rank = 10},
    {suit = 'heart', rank = 11},
    {suit = 'spade', rank = 12},
    {suit = 'club', rank = 13},
}
function drawBackground()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, 220, 220)
    love.graphics.setColor(255, 255, 255)
end
function outputString(output)
    love.graphics.print(table.concat(output, '\n'), 15, 15)
end
local t
t = {
    function ()
        local cardSpacing = 60
        local marginX = 10

        local dealerHand = {
            {
                suit = 'spade',
                rank = 2,
            },
            {
                suit = 'spade',
                rank = 10,
            },
        }

        local playerHand = { {
                suit = 'heart',
                rank = 8,
            },
            {
                suit = 'spade',
                rank = 3,
            },
            {
                suit = 'diamond',
                rank = 11,
            },
        }

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: ?', marginX, 10)
        love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

        love.graphics.setColor(255, 127, 57)
        love.graphics.rectangle('fill', 10, 230, 53, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Hit!', 26, 236)

        love.graphics.setColor(255, 127, 57)
        love.graphics.rectangle('fill', 70, 230, 53, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Stand', 78, 236)
    end,
    function ()
        love.graphics.setFont(font)
        love.graphics.setColor(0, 0, 0)
        love.graphics.print('{')
        love.graphics.translate(16, 16)
        for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
            for rank = 1, 13 do
                love.graphics.print('{suit = \''..suit..'\', rank = '..rank..'},')
                love.graphics.translate(0, 16)
            end
        end
        love.graphics.translate(-16, 0)
        love.graphics.print('}')
    end,
    function ()
        love.graphics.setColor(130, 130, 130)
        love.graphics.rectangle('fill', 0, 0, 204, 95)
        love.graphics.translate(1, 1)
        love.graphics.setColor(255, 255, 255)
        for i = 1, 13 do
            love.graphics.draw(images[i], (i - 1) * 10, 0)
        end
        love.graphics.origin()
        love.graphics.translate(0, 10)
        love.graphics.draw(images.pip_club)
        love.graphics.translate(12, 0)
        love.graphics.draw(images.pip_diamond)
        love.graphics.translate(12, 0)
        love.graphics.draw(images.pip_heart)
        love.graphics.translate(12, 0)
        love.graphics.draw(images.pip_spade)
        love.graphics.translate(12, 0)
        love.graphics.draw(images.mini_club)
        love.graphics.translate(8, 0)
        love.graphics.draw(images.mini_diamond)
        love.graphics.translate(8, 0)
        love.graphics.draw(images.mini_heart)
        love.graphics.translate(8, 0)
        love.graphics.draw(images.mini_spade)
        love.graphics.translate(8, 0)
        love.graphics.origin()
        love.graphics.translate(0, 22)
        love.graphics.draw(images.card)
        love.graphics.translate(54, 0)
        love.graphics.draw(images.card_face_down)
        love.graphics.translate(54, 0)
        love.graphics.draw(images.face_jack)
        love.graphics.translate(32, 0)
        love.graphics.draw(images.face_queen)
        love.graphics.translate(32, 0)
        love.graphics.draw(images.face_king)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1b) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        outputString(output)
    end,
    function ()
        local function getTotal(hand)
            local total = 0
            for cardIndex, card in ipairs(hand) do
                total = total + card.rank
            end
            return total
        end
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        outputString(output)
    end,
    function ()
        local function getTotal(hand)
            local total = 0
            for cardIndex, card in ipairs(hand) do
                if card.rank > 10 then
                    total = total + 10
                else
                    total = total + card.rank
                end
            end
            return total
        end

        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        outputString(output)
    end,

    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        outputString(output)
    end,
    function ()
        local function getTotal(hand)
            local total = 0
            for cardIndex, card in ipairs(hand) do
                if card.rank > 10 then
                    total = total + 10
                else
                    total = total + card.rank
                end
                
                if card.rank == 1 then
                    hasAce = true
                end
            end

            if hasAce and total <= 11 then
                total = total + 10
            end
                
            return total
        end

        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand3) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand3))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        table.insert(output, '')
        table.insert(output, 'Player wins')
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand3) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand3))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer wins')
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand2) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(dealerHand2))
        table.insert(output, '')
        table.insert(output, 'Draw')
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            if cardIndex == 1 then
                table.insert(output, '(Card hidden)')
            else
                table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
            end
        end
        table.insert(output, 'Total: '..getTotal(dealerHand1))
        table.insert(output, '')
        table.insert(output, 'Draw')
        outputString(output)
    end,
    function ()
        drawBackground()

        local output = {}
        table.insert(output, 'Player hand:')
        for cardIndex, card in ipairs(playerHand1) do
            table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
        end
        table.insert(output, 'Total: '..getTotal(playerHand1))
        table.insert(output, '')
        table.insert(output, 'Dealer hand:')
        for cardIndex, card in ipairs(dealerHand1) do
            if cardIndex == 1 then
                table.insert(output, '(Card hidden)')
            else
                table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
            end
        end
        table.insert(output, 'Total: ?')
        outputString(output)
    end,
    function ()
        for cardIndex, card in ipairs(playerHand) do
            love.graphics.draw(images.card, (cardIndex - 1) * 60)
        end
    end,
    function ()
        for cardIndex, card in ipairs(playerHand) do
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, (cardIndex - 1) * 60, 0)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print(card.suit, (cardIndex - 1) * 60, 0)
            love.graphics.print(card.rank, (cardIndex - 1) * 60, 15)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)

            love.graphics.setColor(0, 0, 0)
            love.graphics.print(card.suit, x, y)
            love.graphics.print(card.rank, x, y + 15)
        end

        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)

            love.graphics.setColor(0, 0, 0)
            love.graphics.draw(images[card.rank], x + 3, y + 4)
        end

        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)

            love.graphics.setColor(0, 0, 0)

            local cardWidth = 53
            local cardHeight = 73
            local numberOffsetX = 3
            local numberOffsetY = 4
            love.graphics.draw(
                images[card.rank],
                x + numberOffsetX,
                y + numberOffsetY
            )
            love.graphics.draw(
                images[card.rank],
                x + cardWidth - numberOffsetX - 1,
                y + cardHeight - numberOffsetY,
                0,
                -1
            )
        end 
        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)
            
            love.graphics.setColor(0, 0, 0)

            local cardWidth = 53
            local cardHeight = 73
            local numberOffsetX = 3
            local numberOffsetY = 4
            love.graphics.draw(
                images[card.rank],
                x + numberOffsetX,
                y + numberOffsetY
            )
            love.graphics.draw(
                images[card.rank],
                x + cardWidth - numberOffsetX - 1,
                y + cardHeight - numberOffsetY,
                0,
                -1
            )
            local suitOffsetX = 3
            local suitOffsetY = 14
            local suitImage = images['mini_'..card.suit]
            love.graphics.draw(
                suitImage,
                x + suitOffsetX,
                y + suitOffsetY
            )
            love.graphics.draw(
                suitImage,
                x + cardWidth - suitOffsetX - 1,
                y + cardHeight - suitOffsetY,
                0,
                -1
            )
        end 
        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)

            if card.suit == 'heart' or card.suit == 'diamond' then
                love.graphics.setColor(228, 15, 100)
            else
                love.graphics.setColor(50, 50, 50)
            end

            local cardWidth = 53
            local cardHeight = 73
            local numberOffsetX = 3
            local numberOffsetY = 4
            love.graphics.draw(
                images[card.rank],
                x + numberOffsetX,
                y + numberOffsetY
            )
            love.graphics.draw(
                images[card.rank],
                x + cardWidth - numberOffsetX - 1,
                y + cardHeight - numberOffsetY,
                0,
                -1
            )
            local suitOffsetX = 3
            local suitOffsetY = 14
            local suitImage = images['mini_'..card.suit]
            love.graphics.draw(
                suitImage,
                x + suitOffsetX,
                y + suitOffsetY
            )
            love.graphics.draw(
                suitImage,
                x + cardWidth - suitOffsetX - 1,
                y + cardHeight - suitOffsetY,
                0,
                -1
            )
        end 
        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local function drawCard(card, x, y)
            love.graphics.setColor(255, 255, 255)
            love.graphics.draw(images.card, x, y)

            if card.suit == 'heart' or card.suit == 'diamond' then
                love.graphics.setColor(228, 15, 100)
            else
                love.graphics.setColor(50, 50, 50)
            end

            local cardWidth = 53
            local cardHeight = 73
            local numberOffsetX = 3
            local numberOffsetY = 4
            love.graphics.draw(
                images[card.rank],
                x + numberOffsetX,
                y + numberOffsetY
            )
            love.graphics.draw(
                images[card.rank],
                x + cardWidth - numberOffsetX - 1,
                y + cardHeight - numberOffsetY,
                0,
                -1
            )
            local suitOffsetX = 3
            local suitOffsetY = 14
            local suitImage = images['mini_'..card.suit]
            love.graphics.draw(
                suitImage,
                x + suitOffsetX,
                y + suitOffsetY
            )
            love.graphics.draw(
                suitImage,
                x + cardWidth - suitOffsetX - 1,
                y + cardHeight - suitOffsetY,
                0,
                -1
            )
            if card.rank > 10 then
                local faceImage
                if card.rank == 11 then
                    faceImage = images.face_jack
                elseif card.rank == 12 then
                    faceImage = images.face_queen
                elseif card.rank == 13 then
                    faceImage = images.face_king
                end
                love.graphics.setColor(255, 255, 255)
                love.graphics.draw(faceImage, x + 12, y + 11)
            end
        end 
        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local testHand = {
            {suit = 'club', rank = 1},
            {suit = 'diamond', rank = 1},
            {suit = 'heart', rank = 1},
            {suit = 'spade', rank = 1},
        }
        
        for cardIndex, card in ipairs(testHand) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
    end,
    function ()
        local testHand = {
            {suit = 'club', rank = 2},
            {suit = 'diamond', rank = 2},
            {suit = 'heart', rank = 2},
            {suit = 'spade', rank = 2},
        }
        
        for cardIndex, card in ipairs(testHand) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
    end,
    function ()
        local testHand = {
            {suit = 'club', rank = 3},
            {suit = 'diamond', rank = 3},
            {suit = 'heart', rank = 3},
            {suit = 'spade', rank = 3},
        }
        
        for cardIndex, card in ipairs(testHand) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
    end,
    function ()
        local testHand = {
            {suit = 'club', rank = 4},
            {suit = 'diamond', rank = 4},
            {suit = 'heart', rank = 4},
            {suit = 'spade', rank = 4},
        }
        
        for cardIndex, card in ipairs(testHand) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
    end,
    function ()
        local testHand = {
            {suit = 'club', rank = 1},
            {suit = 'diamond', rank = 2},
            {suit = 'heart', rank = 3},
            {suit = 'spade', rank = 4},
        }
        
        for cardIndex, card in ipairs(testHand) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
    end,
    function ()
        local testHand1 = {
            {suit = 'club', rank = 1},
            {suit = 'diamond', rank = 2},
            {suit = 'heart', rank = 3},
            {suit = 'spade', rank = 4},
            {suit = 'club', rank = 5},
        }
        local testHand2 = {
            {suit = 'diamond', rank = 6},
            {suit = 'heart', rank = 7},
            {suit = 'spade', rank = 8},
            {suit = 'club', rank = 9},
            {suit = 'diamond', rank = 10},
        }
        for cardIndex, card in ipairs(testHand1) do
            drawCard(card, (cardIndex - 1) * 60, 0)
        end
        
        for cardIndex, card in ipairs(testHand2) do
            drawCard(card, (cardIndex - 1) * 60, 80)
        end
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: ?', marginX, 10)
        love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand2) do
            --love.graphics.draw(images.card, marginX, dealerMarginY)
            --love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
        end

        for cardIndex, card in ipairs(playerHand1) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: '..getTotal(dealerHand1), marginX, 10)
        love.graphics.print('Total: '..getTotal(playerHand1), marginX, 120)

        local resultY = 268
        love.graphics.print('Player wins', marginX, resultY)
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: ?', marginX, 10)

        love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

        love.graphics.setColor(255, 127, 57)
        love.graphics.rectangle('fill', 10, 230, 53, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Hit!', 26, 236)

        love.graphics.setColor(255, 127, 57)
        love.graphics.rectangle('fill', 70, 230, 53, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Stand', 78, 236)
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: ?', marginX, 10)
        love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

        love.graphics.setColor(255, 127, 57)
        love.graphics.rectangle('fill', 10, 230, 113, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Play again', 34, 236)
    end,
    function ()
        local cardSpacing = 60
        local marginX = 10

        for cardIndex, card in ipairs(dealerHand) do
            if cardIndex == 1 then
                love.graphics.draw(images.card, marginX, dealerMarginY)
                love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
            else
                drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
            end
        end

        for cardIndex, card in ipairs(playerHand) do
            drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
        end
        love.graphics.setColor(0, 0, 0)

        love.graphics.print('Total: ?', marginX, 10)
        love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

        love.graphics.setColor(255, 202, 75)
        love.graphics.rectangle('fill', 10, 230, 113, 25)
        love.graphics.setColor(255, 255, 255)
        love.graphics.print('Play again', 34, 236)

        love.graphics.setColor(255, 255, 100)
        love.graphics.draw(mouse, 110, 241)
    end,
}
return t
