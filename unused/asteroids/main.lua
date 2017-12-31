function love.load()
    arenaWidth = 800
    arenaHeight = 600

    shipX = arenaWidth / 2
    shipY = arenaHeight / 2
    shipRadius = 30
    shipAngle = 0
    shipSpeedX = 0
    shipSpeedY = 0

    bullets = {}
    bulletTimer = 0
    bulletRadius = 5

    asteroidStages = {
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

    asteroids = {
        {
            x = 100,
            y = 100,
            stage = #asteroidStages,
            angle = love.math.random(2 * math.pi)
        },
        {
            x = arenaWidth - 100,
            y = 100,
            stage = #asteroidStages,
            angle = love.math.random(2 * math.pi)
        },
        {
            x = arenaWidth / 2,
            y = arenaHeight - 100,
            stage = #asteroidStages,
            angle = love.math.random(2 * math.pi)
        }
    }
end

function love.update(dt)
    bulletTimer = bulletTimer + dt

    if love.keyboard.isDown('s') then
        if bulletTimer >= 0.5 then
            bulletTimer = 0

            table.insert(
                bullets,
                {
                    x = shipX + math.cos(shipAngle) * shipRadius,
                    y = shipY + math.sin(shipAngle) * shipRadius,
                    angle = shipAngle,
                    timeLeft = 4,
                }
            )
        end
    end
    
    function rotate(key, direction)
        if love.keyboard.isDown(key) then
            shipAngle = shipAngle + (direction * 10 * dt)
            if shipAngle < 0 then
                shipAngle = shipAngle + (2 * math.pi)
            elseif shipAngle > (2 * math.pi) then
                shipAngle = shipAngle - (2 * math.pi)
            end
        end
    end
    
    rotate('left', -1)
    rotate('right', 1)
    
    if love.keyboard.isDown('up') then
        shipSpeedX = shipSpeedX + math.cos(shipAngle) * 100 * dt
        shipSpeedY = shipSpeedY + math.sin(shipAngle) * 100 * dt
    end

    shipX = shipX + shipSpeedX * dt
    shipY = shipY + shipSpeedY * dt


    local function wrap(position, limit)
        if position < 0 then
            return position + limit
        elseif position > limit then
            return position - limit
        else
            return position
        end
    end

    shipX = wrap(shipX, arenaWidth)
    shipY = wrap(shipY, arenaHeight)

    local function areCirclesIntersecting(aX, aY, aRadius, bX, bY, bRadius)
        return (aX - bX)^2 + (aY - bY)^2 <= (aRadius + bRadius)^2
    end

    for bulletIndex = #bullets, 1, -1 do
        local bullet = bullets[bulletIndex]

        bullet.timeLeft = bullet.timeLeft - dt
        if bullet.timeLeft <= 0 then
            table.remove(bullets, bulletIndex)
        else
            local bulletSpeed = 500
            bullet.x = wrap(bullet.x + math.cos(bullet.angle) * bulletSpeed * dt, arenaWidth)
            bullet.y = wrap(bullet.y + math.sin(bullet.angle) * bulletSpeed * dt, arenaHeight)
        end

        for asteroidIndex = #asteroids, 1, -1 do
            local asteroid = asteroids[asteroidIndex]

            if areCirclesIntersecting(bullet.x, bullet.y, bulletRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
                table.remove(bullets, bulletIndex)
                if asteroid.stage > 1 then
                    local angle1 = love.math.random(2 * math.pi)
                    local angle2 = angle1 - math.pi
                    if angle2 < 0 then
                        angle2 = angle2 + (2 * math.pi)
                    end
                    table.insert(asteroids, {
                        x = asteroid.x,
                        y = asteroid.y,
                        angle = angle1,
                        stage = asteroid.stage - 1
                    })
                    table.insert(asteroids, {
                        x = asteroid.x,
                        y = asteroid.y,
                        angle = angle2,
                        stage = asteroid.stage - 1
                    })
                end

                table.remove(asteroids, asteroidIndex)

                break
            end
        end
    end

    for asteroidIndex = #asteroids, 1, -1 do
        local asteroid = asteroids[asteroidIndex]
        local asteroidSpeed = asteroidStages[asteroid.stage].speed

        asteroid.x = wrap(asteroid.x + math.cos(asteroid.angle) * asteroidSpeed * dt, arenaWidth)
        asteroid.y = wrap(asteroid.y + math.sin(asteroid.angle) * asteroidSpeed * dt, arenaHeight)

        if areCirclesIntersecting(shipX, shipY, shipRadius, asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius) then
            love.load()
            break
        end
    end

    if #asteroids == 0 then
        love.load()
    end
end

function love.draw()
    for y = -1, 1 do
        for x = -1, 1 do
            love.graphics.origin()
            love.graphics.translate(x * arenaWidth, y * arenaHeight)

            love.graphics.setColor(0, 0, 1)
            love.graphics.circle('fill', shipX, shipY, shipRadius)
            love.graphics.setColor(0, 1, 1)
            love.graphics.circle('fill', shipX + math.cos(shipAngle) * 20, shipY + math.sin(shipAngle) * 20, 5)

            for bulletIndex, bullet in ipairs(bullets) do
                love.graphics.setColor(0, 1, 0)
                love.graphics.circle('fill', bullet.x, bullet.y, bulletRadius)
            end

            for asteroidIndex, asteroid in ipairs(asteroids) do
                love.graphics.setColor(1, 1, 0)
                love.graphics.circle('fill', asteroid.x, asteroid.y, asteroidStages[asteroid.stage].radius)
            end
        end
    end
end
