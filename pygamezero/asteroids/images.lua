local t

font = love.graphics.newFont('freesansbold.ttf', 16)

local arenaWidth = 800
local arenaHeight = 600
local ship_x = arenaWidth/2
local ship_y = arenaHeight/2
local shipRadius = 30
local bulletRadius = 5
local asteroidStages = {
    {
        speed = 120,
        radius = 15
    },
    {
        speed = 70,
        radius = 30
    },
    {
        speed = 50,
        radius = 50
    },
    {
        speed = 20,
        radius = 80
    }
}

local function drawBackground()
    love.graphics.setColor(0, 0, 0)
    love.graphics.rectangle('fill', 0, 0, arenaWidth, arenaHeight)
end

local function drawShip(ship_x, ship_y, ship_angle)
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', ship_x, ship_y, 30)
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle('fill', ship_x + math.cos(ship_angle) * 20, ship_y + math.sin(ship_angle) * 20, 5)
end

local state={asteroids={
    {y=432.79187776402739,x=500.69528311154772,stage=3,angle=2},
    {y=477.44197041640007,x=629.75993635474151,stage=1,angle=7},
    {y=450.92502116704247,x=539.3965130488582,stage=2,angle=2},
    {y=231.05235123145113,x=435.33463277473066,stage=1,angle=5.1415926535897931},
    {y=372.85112417427746,x=178.9983516984791,stage=1,angle=5},
    {y=194.45765557537253,x=790.904856835020297,stage=4,angle=1.8584073464102069},
    {y=573.22264220883255,x=472.01183126800373,stage=3,angle=4},
    {y=499.31802801248818,x=584.00167031059198,stage=2,angle=5},
    {y=156.91434283484284,x=508.39297922356326,stage=2,angle=1.8584073464102069}},
bullets={
    {y=137.0795815932228,x=166.39759662887332,timeLeft=2.4971007055009977,angle=4.5611458247554282},
    {y=92.764864463839871,x=782.1603318714607,timeLeft=2.998316628433713,angle=5.8910186366852457},
    {y=240,x=380},
    {y=170.37102522679254,x=568.27371716760695,timeLeft=3.4990301677498792,angle=5.8910186366852457}
},bulletTimer=0.48400967049838073,ship_speed_y=-38.649422672932722,ship_x=329.63758865193228,ship_speed_x=41.030924422085342,ship_angle=5.8910186366852457,ship_y=258.20777966622228}

local function drawGame(state)
    love.graphics.setColor(0, 0, 1)
    love.graphics.circle('fill', state.ship_x, state.ship_y, shipRadius)
    love.graphics.setColor(0, 1, 1)
    love.graphics.circle('fill', state.ship_x + math.cos(state.ship_angle) * 20, state.ship_y + math.sin(state.ship_angle) * 20, 5)

    for bulletIndex, bullet in ipairs(state.bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
    end

    for asteroidIndex, asteroid in ipairs(state.asteroids) do
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle('fill', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
    end
end

local function getCanvas(f)
    local c = love.graphics.newCanvas(arenaWidth, arenaHeight)
    c:renderTo(function ()
        drawBackground()
        for y = -1, 1 do
            for x = -1, 1 do
                love.graphics.origin()
                love.graphics.translate(x * arenaWidth, y * arenaHeight)

                f()
            end
        end
    end)
    love.graphics.origin()
    return c
end

local function drawCanvas(f)
    local c = getCanvas(f)
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(c, 0, 0)
end

local function drawBullets(bullets)
    for bulletIndex, bullet in ipairs(bullets) do
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle('fill', bullet.x, bullet.y, 5)
    end
end

t = {
    function ()
        drawCanvas(function()
            drawGame(state)
        end)
    end,
    function ()
        local c = love.graphics.newCanvas(arenaWidth * 3 + 300, arenaHeight * 3 + 300)
        c:renderTo(function ()
            love.graphics.setColor(0, 0, 0)
            love.graphics.rectangle('fill', 0, 0, arenaWidth * 3, arenaHeight * 3)
        end)
        for y = 0, 2 do
            for x = 0, 2 do
                local c2 = love.graphics.newCanvas(arenaWidth + 300, arenaHeight + 300)
                c2:renderTo(function()
                    love.graphics.setColor(1, 1, 1)
                    drawGame(state)
                    love.graphics.setFont(love.graphics.newFont(100))
                end)
                if y == 1 and x == 1 then
                    love.graphics.setColor(1, 1, 1)
                else
                    love.graphics.setColor(.3, .3, .3, .3)
                end
                love.graphics.origin()
                c:renderTo(function()
                    love.graphics.push('all')
                    love.graphics.setBlendMode('alpha', 'premultiplied')
                    love.graphics.draw(c2, x * arenaWidth, y * arenaHeight)
                    love.graphics.pop()
                end)
            end
        end
        love.graphics.origin()
        love.graphics.setColor(1, 1, 1)
        love.graphics.push('all')
        love.graphics.setBlendMode('alpha', 'premultiplied')
        local scale = .32
        love.graphics.push('all')
        love.graphics.setBlendMode('alpha', 'premultiplied')
        love.graphics.draw(c, 0, 0, 0, scale)
        love.graphics.pop()
        love.graphics.setColor(1, 0, 0)
        love.graphics.rectangle('line', arenaWidth * scale + .5, arenaHeight * scale + .5, arenaWidth * scale, arenaHeight * scale)
        love.graphics.pop()
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(20, 30)
        aX = 50
        aY = 50
        bX = 150
        bY = 120
        aRadius = 30
        bRadius = 50
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 1)
        local s = 15
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.line(aX, aY, bX, bY)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.print('a', aX + 32, bY + 2)
        love.graphics.print('b', aX - 20, aY + 30)
        love.graphics.print('c', aX + 43, bY - 67)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(20, 30)
        aX = 50
        aY = 50
        bX = 150
        bY = 120
        aRadius = 30
        bRadius = 50
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle('fill', aX, aY, aRadius)
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle('fill', bX, bY, bRadius)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 1)
        local s = 15
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.line(aX, aY, bX, bY)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.print('a', aX + 32, bY + 2)
        love.graphics.print('b', aX - 20, aY + 30)
        love.graphics.print('c', aX + 43, bY - 67)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(20, 30)
        aX = 50
        aY = 50
        bX2 = 150
        bY2 = 120
        aRadius = 30
        bRadius = 50
        local angle = math.atan2((bY2 - aY), (bX2 - aX))
        local startX = aX
        local startY = aY
        local endX = startX + aRadius * math.cos(angle)
        local endY = startY + aRadius * math.sin(angle)
        local startX2 = endX
        local startY2 = endY
        local endX2 = startX2 + bRadius * math.cos(angle)
        local endY2 = startY2 + bRadius * math.sin(angle)
        bX = endX2
        bY = endY2
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1, .25)
        love.graphics.circle('fill', startX, startY, aRadius)
        love.graphics.setColor(1, 1, 0, .25)
        love.graphics.circle('fill', endX2, endY2, bRadius)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 1)
        local s = 15
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.line(aX, aY, bX, bY)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.setColor(0, 0, 1)
        love.graphics.line(startX, startY, endX, endY)
        love.graphics.setColor(1, 1, 0)
        love.graphics.line(startX2, startY2, endX2, endY2)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(20, 30)
        aX = 50
        aY = 50
        bX = 150
        bY = 120
        aRadius = 30
        bRadius = 50
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle('fill', aX, aY, aRadius)
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle('fill', bX, bY, bRadius)
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 1)
        local s = 15
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.line(aX, aY, bX, bY)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.print('a', aX + 32, bY + 2)
        love.graphics.print('b', aX - 20, aY + 30)
        love.graphics.print('c', aX + 43, bY - 67)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(20, 30)
        aX = 50
        aY = 50
        bX = 150
        bY = 120
        aRadius = 30
        bRadius = 50
        local angle = math.atan2((bY - aY), (bX - aX))
        local startX = aX + 5
        local startY = aY + -5
        local endX = startX + aRadius * math.cos(angle)
        local endY = startY + aRadius * math.sin(angle)
        local startX2 = endX
        local startY2 = endY
        local endX2 = startX2 + bRadius * math.cos(angle)
        local endY2 = startY2 + bRadius * math.sin(angle)
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1, .25)
        love.graphics.setColor(1, 1, 0, .25)
        love.graphics.setLineWidth(3)
        local s = 15
        love.graphics.setColor(.2, .2, .2)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.setColor(0, 0, 1)
        love.graphics.line(startX, startY, endX, endY)
        love.graphics.setColor(1, 1, 0)
        love.graphics.line(startX2, startY2, endX2, endY2)
        love.graphics.setColor(1, 0, 1)
        love.graphics.line(aX, aY, bX, bY)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(40, 40)
        aX = 50
        aY = 50
        bX = 100
        bY = 100
        aRadius = 30
        bRadius = 50
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1)
        love.graphics.push('all')
        love.graphics.setBlendMode('add')
        love.graphics.circle('fill', aX, aY, aRadius)
        love.graphics.setColor(1, 1, 0)
        love.graphics.circle('fill', bX, bY, bRadius)
        love.graphics.pop()
        love.graphics.setLineWidth(3)
        love.graphics.setColor(1, 0, 1)
        local s = 15
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.line(aX, aY, bX, bY)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.print('a', aX + 15, bY + 2)
        love.graphics.print('b', aX - 20, aY + 14)
        love.graphics.print('c', aX + 27, bY - 46)
    end,
    function ()
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle('fill', 0, 0, 240, 240)
        love.graphics.translate(40, 40)
        aX = 50
        aY = 50
        bX = 100
        bY = 100
        aRadius = 30
        bRadius = 50
        local angle = math.atan2((bY - aY), (bX - aX))
        local startX = aX + 5
        local startY = aY + -5
        local endX = startX + aRadius * math.cos(angle)
        local endY = startY + aRadius * math.sin(angle)
        local startX2 = endX
        local startY2 = endY
        local endX2 = startX2 + bRadius * math.cos(angle)
        local endY2 = startY2 + bRadius * math.sin(angle)
        love.graphics.setFont(love.graphics.newFont(20))
        love.graphics.setColor(0, 0, 1, .25)
        love.graphics.setColor(1, 1, 0, .25)
        love.graphics.setLineWidth(3)
        local s = 15
        love.graphics.setColor(.2, .2, .2)
        love.graphics.line(aX, aY, aX, bY)
        love.graphics.line(aX, bY, bX, bY)
        love.graphics.line(aX + s, bY, aX + s, bY - s)
        love.graphics.line(aX + s, bY - s, aX, bY - s)
        love.graphics.setColor(0, 0, 1)
        love.graphics.line(startX, startY, endX, endY)
        love.graphics.setColor(1, 1, 0)
        love.graphics.line(startX2, startY2, endX2, endY2)
        love.graphics.setColor(1, 0, 1)
        love.graphics.line(aX, aY, bX, bY)
    end,
    function ()
        drawBackground()
        love.graphics.setColor(0, 0, 1)
        love.graphics.circle('fill', ship_x, ship_y, 30)
    end,
    function ()
        love.graphics.setFont(font)
        drawBackground()
        local state={asteroids={},bullets={},
            ship_x=ship_x,
            ship_y=ship_y,
            ship_angle=0.66086477996577742,
        }
        drawCanvas(function()
            drawGame(state)
        end)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print('ship_angle: '..state.ship_angle)
    end,
    function ()
        love.graphics.setFont(font)
        drawBackground()
        local state={asteroids={},bullets={},
            ship_x=ship_x + 38.23875491101745,
            ship_angle=0.66086477996577742,
            ship_y=ship_y + 31.6100359214243,
            ship_speed_x=63.23140354795430,
            ship_speed_y=49.161879698613781,
        }
        drawCanvas(function()
            drawGame(state)
        end)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(table.concat({
            'ship_angle: '..state.ship_angle,
            'ship_x: '..state.ship_x,
            'ship_y: '..state.ship_y,
            'ship_speed_x: '..state.ship_speed_x,
            'ship_speed_y: '..state.ship_speed_y,
        }, '\n'))
    end,
    function ()
        love.graphics.setFont(font)
        drawBackground()
        local state={asteroids={},bullets={},
            ship_x=ship_x + 398.23875491101745,
            ship_angle=0.66086477996577742,
            ship_y=ship_y + 31.6100359214243,
            ship_speed_x=63.23140354795430,
            ship_speed_y=49.161879698613781,
        }
        drawCanvas(function()
            drawGame(state)
        end)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(table.concat({
            'ship_angle: '..state.ship_angle,
            'ship_x: '..state.ship_x,
            'ship_y: '..state.ship_y,
            'ship_speed_x: '..state.ship_speed_x,
            'ship_speed_y: '..state.ship_speed_y,
        }, '\n'))
    end,
    function ()
        drawBackground()
        local state={asteroids={},
            ship_x=550,
            ship_angle=0,
            ship_y=ship_y,
            ship_speed_x=63.23140354795430,
            ship_speed_y=49.161879698613781,
            bullets = {
                {x = 400, y = 300},
                {x = 500, y = 300},
                {x = 550, y = 300},
            }
        }
        drawCanvas(function()
            drawGame(state)
        end)
    end,
    function ()
        drawBackground()
        local state={asteroids={},
            ship_x=ship_x,
            ship_angle=0.66086477996577742,
            ship_y=ship_y,
            ship_speed_x=63.23140354795430,
            ship_speed_y=49.161879698613781,
        }
        state.bullets = {
            {
                x = state.ship_x + math.cos(state.ship_angle) * shipRadius,
                y = state.ship_y + math.sin(state.ship_angle) * shipRadius
            }
        }
        drawCanvas(function()
            drawGame(state)
        end)
    end,
    function ()
        drawCanvas(function()
            local asteroids = {
                {
                    x = 100,
                    y = 100,
                },
                {
                    x = arenaWidth - 100,
                    y = 100,
                },
                {
                    x = arenaWidth / 2,
                    y = arenaHeight - 100,
                }
            }

            local ship_x = arenaWidth / 2
            local ship_y = arenaHeight / 2
            local ship_angle = 0
            drawShip(arenaWidth / 2, arenaHeight / 2, 0)

            for asteroidIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 0)
                love.graphics.circle('fill', asteroid.x, asteroid.y, 80)
            end
        end)
    end,
}

return t
