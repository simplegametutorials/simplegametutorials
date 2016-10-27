function love.load()
	images = {}
	for imageIndex, image in ipairs({
		1, 2, 3, 4, 5, 6, 7, 8,
		'uncovered', 'covered_highlighted', 'covered', 'flower', 'flag', 'question',
	}) do
		images[image] = love.graphics.newImage('images/'..image..'.png')
	end

	cellSize = 18

	gridXCount = 19
	gridYCount = 14

	function getSurroundingFlowerCount(x, y)
		local surroundingFlowerCount = 0

		for dy = -1, 1 do
			for dx = -1, 1 do
				if not (dy == 0 and dx == 0)
				and grid[y + dy]
				and grid[y + dy][x + dx]
				and grid[y + dy][x + dx].flower then
					surroundingFlowerCount = surroundingFlowerCount + 1
				end
			end
		end

		return surroundingFlowerCount
	end

	function reset()
		grid = {}
		for y = 1, gridYCount do
			grid[y] = {}
			for x = 1, gridXCount do
				grid[y][x] = {
					flower = false,
					state = 'covered', -- 'covered', 'uncovered', 'flag', 'question'
				}
			end
		end

		gameOver = false
		firstClick = true
	end

	reset()
end

function love.update()
	selectedX = math.floor(love.mouse.getX() / cellSize) + 1
	selectedY = math.floor(love.mouse.getY() / cellSize) + 1

	if selectedX > gridXCount then
		selectedX = gridXCount
	end
	if selectedY > gridYCount then
		selectedY = gridYCount
	end
end

function love.draw()
	for y = 1, gridYCount do
		for x = 1, gridXCount do
			local function drawCell(image, x, y)
				love.graphics.draw(image, (x - 1) * cellSize, (y - 1) * cellSize)
			end

			if grid[y][x].state == 'uncovered' then
				drawCell(images.uncovered, x, y)
			else
				if x == selectedX and y == selectedY and not gameOver then
					if love.mouse.isDown(1) then
						if grid[y][x].state == 'flag' then
							drawCell(images.covered, x, y)
						else
							drawCell(images.uncovered, x, y)
						end
					else
						drawCell(images.covered_highlighted, x, y)
					end
				else
					drawCell(images.covered, x, y)
				end
			end

			if grid[y][x].flower and gameOver then
				drawCell(images.flower, x, y)
			elseif getSurroundingFlowerCount(x, y) > 0 and grid[y][x].state == 'uncovered' then
				drawCell(images[getSurroundingFlowerCount(x, y)], x, y)
			end

			if grid[y][x].state == 'flag' then
				drawCell(images.flag, x, y)
			elseif grid[y][x].state == 'question' then
				drawCell(images.question, x, y)
			end
		end
	end
end

function love.mousereleased(mouseX, mouseY, button)
	if not gameOver then
		if button == 1 and grid[selectedY][selectedX].state ~= 'flag' then
			if firstClick then
				firstClick = false

				local possibleFlowerPositions = {}
				for y = 1, gridYCount do
					for x = 1, gridXCount do
						if not (x == selectedX and y == selectedY) then
							table.insert(possibleFlowerPositions, {x = x, y = y})
						end
					end
				end

				for flowerIndex = 1, 40 do
					local position = table.remove(possibleFlowerPositions, love.math.random(#possibleFlowerPositions))
					grid[position.y][position.x].flower = true
				end
			end

			if grid[selectedY][selectedX].flower then
				grid[selectedY][selectedX].state = 'uncovered'
				gameOver = true
			else
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

					if getSurroundingFlowerCount(x, y) == 0 then
						for dy = -1, 1 do
							for dx = -1, 1 do
								if not (dx == 0 and dy == 0)
								and grid[y + dy]
								and grid[y + dy][x + dx]
								and (
									grid[y + dy][x + dx].state == 'covered'
									or grid[y + dy][x + dx].state == 'question'
								) then
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

				local complete = true

				for y = 1, gridYCount do
					for x = 1, gridXCount do
						if grid[y][x].state ~= 'uncovered' and not grid[y][x].flower then
							complete = false
						end
					end
				end

				if complete then
					gameOver = true
				end
			end
		elseif button == 2 then
			if grid[selectedY][selectedX].state == 'covered' then
				grid[selectedY][selectedX].state = 'flag'
			elseif grid[selectedY][selectedX].state == 'flag' then
				grid[selectedY][selectedX].state = 'question'
			elseif grid[selectedY][selectedX].state == 'question' then
				grid[selectedY][selectedX].state = 'covered'
			end
		end
	else
		reset()
	end
end
