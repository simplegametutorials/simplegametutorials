function love.load()
	love.graphics.setDefaultFilter( 'nearest', 'nearest' )
	font = love.graphics.getFont()
	screenWidth, screenHeight = love.graphics.getDimensions()

	highScore = 0
	if love.filesystem.exists( 'file.lua' ) then
		highScore = love.filesystem.load( 'file.lua' )()
	end

	states = {
		playing = {
			update = function( dt )
				updateAsteroids( dt )
				updateShip( dt )
				destroyAsteroids()
			end,
			draw = function()
				love.graphics.setColor( 255, 255, 255 )
				love.graphics.print( 'Score: ' .. score, 2, 2 )

				-- We're not rotating the ship, so no need for offset
				love.graphics.draw( shipImage, shipX, shipY )

				drawAsteroids()

				-- Collision debug if you want to visualize it.
				if DEBUG then
					love.graphics.setColor( 255, 0, 0 )
					love.graphics.circle( 'line', shipX + shipWidth - shipWidth / 3, shipY + shipHeight / 1.4, shipWidth / 6.5 )
					love.graphics.circle( 'line', shipX + shipWidth / 3, shipY + shipHeight / 1.4, shipWidth / 6.5 )
					love.graphics.circle( 'line', shipX + shipWidth / 2, shipY + shipHeight / 2.5, shipWidth / 5 )
					for i = 1, #asteroids do
						love.graphics.circle( 'line', asteroids[i].x, asteroids[i].y, asteroids[i].radius )
					end
				end
			end,
			keypressed = function( key )
				if ( key == 'left' or key == 'a' ) then
					shipVelocityX = -shipMoveSpeed
				end
				if ( key == 'right' or key == 'd' ) then
					shipVelocityX = shipMoveSpeed
				end
				if key == '`' then DEBUG = not DEBUG end
			end,
			keyreleased = function( key )
				shipVelocityX = 0
				updateShipVelocity()
			end,
			mousereleased = function( x, y, button ) end
		},
		lose = {
			update = function( dt )
				replay:update( dt )
				quit:update( dt )
			end,
			draw = function()
				replay:draw()
				quit:draw()

				love.graphics.setColor( 255, 255, 255 )
				love.graphics.printf( 'High score: ' .. highScore, 0, screenHeight / 2, screenWidth, 'center' )
			end,
			keypressed = function( key ) end,
			keyreleased = function( key ) end,
			mousereleased = function( x, y, button )
				if button == 1 then
					local clickedButton = checkButtons( x, y )
					if clickedButton then
						activeButtons[clickedButton].callback()
					end
				end
			end,
		}
	}

	score = 0
	difficulty = 1
	asteroidsPassed = 0
	state = 'playing'

	-- The image, width, and height will be the same for all asteroids, so we only need one of these
	asteroidImage = love.graphics.newImage( 'asteroid.png' )
	asteroidWidth, asteroidHeight = asteroidImage:getDimensions()

	shipImage = love.graphics.newImage( 'ship.png' )
	shipWidth, shipHeight = shipImage:getDimensions()
	shipX, shipY = ( 300 - shipWidth ) / 2, 500
	shipVelocityX, shipVelocityY = 0, 0
	shipMoveSpeed = 256

	function AABB( object1x, object1y, object1w, object1h, object2x, object2y, object2w, object2h )
		return ( object1x + object1w >= object2x and
			     object1x <= object2x + object2w and
			     object1y + object1h >= object2y and
			     object1y <= object2y + object2h )
	end

	function circleCircle( object1x, object1y, object1r, object2x, object2y, object2r )
		return math.sqrt( ( object1x - object2x ) ^ 2 + ( object1y - object2y ) ^ 2 ) <= object1r + object2r
	end

	function asteroidCollision( asteroid )
		-- Since the asteroid is a square its radius is half the width (or height)
		-- This is also true of the ship, although its image is not offset
		return circleCircle( asteroid.x, asteroid.y, asteroid.radius, shipX + shipWidth / 2, shipY + shipHeight / 2.5, shipWidth / 5 )
			or circleCircle( asteroid.x, asteroid.y, asteroid.radius, shipX + shipWidth / 3, shipY + shipHeight / 1.4, shipWidth / 6.5 )
			or circleCircle( asteroid.x, asteroid.y, asteroid.radius, shipX + shipWidth / 3 + shipWidth / 2, shipY + shipHeight / 1.4, shipWidth / 6.5 )
	end

	-- "object" is any table with values for "x", "y", "width", and "height"
	function mouseAABB( mouseX, mouseY, object )
		return AABB( object.x, object.y, object.width, object.height, mouseX, mouseY, 0, 0 )
	end

	toDestroy = {}
	ID = 0

	function destroyAsteroids()
		for i = 1, #toDestroy do
			for j = 1, #asteroids do
				if toDestroy[i] == asteroids[j].id then
					table.remove( asteroids, j )
					break
				end
			end
		end
	end

	function createAsteroid( x, y, velocityX, velocityY, rotationSpeed, radius )
		ID = ID + 1
		local asteroid = {
			x = x,
			y = y,
			id = ID,
			rotation = 0,
			rotationSpeed = rotationSpeed,
			velocityX = velocityX,
			velocityY = velocityY,
			-- "or" allows a defualt value if `radius` isn't defined
			radius = radius or asteroidWidth / 2,
			update = function( self, dt )
				self.x = self.x + self.velocityX * dt
				self.y = self.y + self.velocityY * dt
				self.rotation = self.rotation + self.rotationSpeed * dt

				if self.y - self.radius > screenHeight then
					score = score + 50
					table.insert( toDestroy, self.id )
					table.insert( asteroids, randomAsteroid() )
					asteroidsPassed = asteroidsPassed + 1
					if asteroidsPassed % 5 == 0 then
						difficulty = difficulty + .1
					end
				end
				if self.velocityX < 0 and self.x + self.radius < 0 then
					self.x = self.x + screenWidth + self.radius * 2
				elseif self.velocityX > 0 and self.x - self.radius > screenWidth then
					self.x = self.x - screenWidth - self.radius * 2
				end

				if asteroidCollision( self ) then
					state = 'lose'
					if score > highScore then
						highScore = score
						love.filesystem.write( 'file.lua', 'return ' .. score )
					end
				end
			end,
		}
		-- Defined outside of the table so we can reference the radius
		asteroid.scale = asteroid.radius / ( asteroidWidth / 2 )

		-- Implicit `self` parameter with the colon syntax
		function asteroid:draw()
			love.graphics.draw( asteroidImage, self.x, self.y, self.rotation, self.scale, self.scale, asteroidWidth / 2, asteroidWidth / 2 )
		end

		return asteroid
	end

	function randomAsteroid()
		local vectorMagnitude = love.math.random( 100, 200 ) * difficulty
		local vectorAngle = ( 2 / 3 * math.pi - math.pi / 3 ) * love.math.random() + math.pi / 3
		local vectorX = vectorMagnitude * math.cos( vectorAngle )
		local vectorY = vectorMagnitude * math.sin( vectorAngle )

		local radius = love.math.random( asteroidWidth / 3, 2 / 3 * asteroidWidth ) * difficulty

		return createAsteroid( love.math.random( 0, screenWidth ), -asteroidHeight, vectorX, vectorY, love.math.random( -math.pi / 4, math.pi / 4 ), radius )
	end

	asteroids = {}
	for i = 1, 6 do
		table.insert( asteroids, randomAsteroid() )
	end

	function updateAsteroids( dt )
		for i = 1, #asteroids do
			asteroids[i]:update( dt )
		end
	end

	function drawAsteroids()
		for i = 1, #asteroids do
			asteroids[i]:draw()
		end
	end

	function createButton( text, x, y, width, height, callback )
		-- Vertical centering
		local _, lines = font:getWrap( text, width - 4 )
		local numLines = #lines
		local fontHeight = font:getHeight( 'A' )
		local textHeight = numLines * ( fontHeight + 2 ) - 2
		local textY = y + ( height - textHeight ) / 2

		local button = {
			text = text,
			x = x,
			y = y,
			width = width,
			height = height,
			callback = callback,
			color = { 255, 255, 255 },
			update = function( self, dt )
				local mouseX, mouseY = love.mouse.getPosition()
				if mouseAABB( mouseX, mouseY, self ) then
					self.color = { 125, 125, 125 }
				else
					self.color = { 255, 255, 255 }
				end
			end,
			draw = function( self )
				love.graphics.setColor( self.color )
				love.graphics.rectangle( 'fill', self.x, self.y, self.width, self.height )

				love.graphics.setColor( 0, 0, 0 )
				love.graphics.printf( text, self.x + 2, textY, self.width - 4, 'center' )
			end,
		}

		return button
	end

	replay = createButton( 'Replay?', 2, 2, 50, 50, love.load )
	quit = createButton( 'Quit?', 52, 52, 50, 50, love.event.quit )

	activeButtons = { replay, quit }

	function checkButtons( mouseX, mouseY )
		for i = 1, #activeButtons do
			local result = mouseAABB( mouseX, mouseY, activeButtons[i] )
			if result then return i end
		end
	end

	function updateShip( dt )
		local futureX = shipX + shipVelocityX * dt
		local futureY = shipY + shipVelocityY * dt
		
		if futureX < 0 then
			futureX = 0
		elseif futureX + shipWidth > screenWidth then
			futureX = screenWidth - shipWidth
		end

		shipX = futureX
		shipY = futureY
	end

	function updateShipVelocity()
		if ( love.keyboard.isDown( 'left' ) or love.keyboard.isDown( 'a' ) ) then
			shipVelocityX = -shipMoveSpeed
		end
		if ( love.keyboard.isDown( 'right' ) or love.keyboard.isDown( 'd' ) ) then
			shipVelocityX = shipMoveSpeed
		end
	end
end

function love.update( dt )
	states[state].update( dt )
end

function love.draw()
	states[state].draw()
end

function love.keypressed( key )
	states[state].keypressed( key )
end

function love.keyreleased( key )
	states[state].keyreleased( key )
end

function love.mousereleased( x, y, button )
	states[state].mousereleased( x, y, button )
end
