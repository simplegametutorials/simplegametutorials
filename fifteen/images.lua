local pieceSize = 100
local pieceDrawSize = pieceSize - 1
local pieceColor = {100, 20, 150}
local pieceXCount = 4
local pieceYCount = 4
love.graphics.setNewFont(30)
font = love.graphics.newFont('SourceCodePro-Regular.ttf', 12)
local function getInitialValue(x, y)
	return x + ((y - 1) * pieceXCount)
end
local function drawBackground()
	love.graphics.setColor(0, 0, 0)
	love.graphics.rectangle('fill', 0, 0, pieceXCount * pieceSize, pieceYCount * pieceSize)
end
local function drawGrid(grid)
	for y = 1, pieceYCount do
		for x = 1, pieceXCount do
			if grid[y][x] ~= pieceYCount * pieceXCount then
				love.graphics.setColor(pieceColor)
				love.graphics.rectangle('fill', (x - 1) * pieceSize, (y - 1) * pieceSize, pieceDrawSize, pieceDrawSize)
				love.graphics.setColor(255, 255, 255)
				love.graphics.print(grid[y][x], (x - 1) * pieceSize, (y - 1) * pieceSize)
			end
		end
	end
end
local function createGrid()
	local grid = {}

	for y = 1, pieceYCount do
		grid[y] = {}
		for x = 1, pieceXCount do
			grid[y][x] = getInitialValue(x, y)
		end
	end

	return grid
end
local function drawTable(t)
	love.graphics.push('all')
	local blockSize = 20
	local blockDrawSize = blockSize - 1
	local moveSize = blockSize + 10
	love.graphics.setColor(0, 0, 0)
	love.graphics.print('{', 0, 1)
	love.graphics.translate(10, 0)
	for x = 1, #t do
		--local color = colors[t[x]]
		if t[x] == 16 then
			love.graphics.setColor(100, 100, 100)
		else
			love.graphics.setColor(pieceColor)
		end
		love.graphics.rectangle(
			'fill',
			(x - 1) * moveSize,
			0,
			blockDrawSize,
			blockDrawSize
		)
		love.graphics.setColor(0, 0, 0)
		local function f2(s)
			love.graphics.print(
				s,
				(x - 1) * moveSize + 20,
				1
			)
		end
		local function f(s)
			love.graphics.printf(
				s,
				(x - 1) * moveSize + 0,
				1, blockSize, 'center'
			)
		end
		love.graphics.setColor(255, 255, 255)
		f(t[x])
		love.graphics.setColor(0, 0, 0)
		if x ~= #t then
			f2(',')
		end
	end
	love.graphics.print('},', #t * moveSize - 8, 1)
	love.graphics.pop()
end

local function drawTable2(t)
	love.graphics.setFont(font)
	love.graphics.setColor(0, 0, 0)
	love.graphics.print('{', 0, 0)

	love.graphics.push('all')
	love.graphics.translate(20, 20)
	for y = 1, #t do
		drawTable(t[y])
		love.graphics.translate(0, 30)
	end
	love.graphics.pop()

	love.graphics.print('}', 0, #t * 30 + 10)
end

local t
t = {
	function()
		drawBackground()
		local grid = {
			{10, 8, 1, 9},
			{6, 14, 4, 15},
			{12, 11, 5, 7},
			{2, 3, 13, 16}
		}
		drawGrid(grid)
	end,

	---[[
	function ()
		local grid = {
			{10, 8, 1, 9},
			{6, 14, 4, 15},
			{12, 11, 5, 7},
			{2, 3, 13, 16}
		}
		drawTable2(grid)
	end,
	--]]

	function()
		drawBackground()
		for y = 1, pieceYCount do
			for x = 1, pieceXCount do
				love.graphics.setColor(pieceColor)
				love.graphics.rectangle('fill', (x - 1) * pieceSize, (y - 1) * pieceSize, pieceDrawSize, pieceDrawSize)
			end
		end
	end,
	function()
		drawBackground()
		love.graphics.setNewFont(12)
		for y = 1, pieceYCount do
			for x = 1, pieceXCount do
				love.graphics.setColor(pieceColor)
				love.graphics.rectangle('fill', (x - 1) * pieceSize, (y - 1) * pieceSize, pieceDrawSize, pieceDrawSize)
				love.graphics.setColor(255, 255, 255)
				love.graphics.print(((y - 1) * pieceXCount) + x, (x - 1) * pieceSize, (y - 1) * pieceSize)
			end
		end
		love.graphics.setNewFont(30)
	end,
	function()
		drawBackground()
		for y = 1, pieceYCount do
			for x = 1, pieceXCount do
				love.graphics.setColor(pieceColor)
				love.graphics.rectangle('fill', (x - 1) * pieceSize, (y - 1) * pieceSize, pieceDrawSize, pieceDrawSize)
				love.graphics.setColor(255, 255, 255)
				love.graphics.print(((y - 1) * pieceXCount) + x, (x - 1) * pieceSize, (y - 1) * pieceSize)
			end
		end
	end,
	function()
		drawBackground()
		local grid = createGrid()
		drawGrid(grid)
	end,
	function()
		drawBackground()
		local grid = createGrid()
		grid[pieceYCount - 1][pieceXCount], grid[pieceYCount][pieceXCount] =
		grid[pieceYCount][pieceXCount], grid[pieceYCount - 1][pieceXCount]
		drawGrid(grid)
	end,
	function()
		drawBackground()
		local grid = createGrid()
		grid[pieceYCount - 1][pieceXCount], grid[pieceYCount][pieceXCount] =
		grid[pieceYCount][pieceXCount], grid[pieceYCount - 1][pieceXCount]

		grid[pieceYCount - 1][pieceXCount - 1], grid[pieceYCount - 1][pieceXCount] =
		grid[pieceYCount - 1][pieceXCount], grid[pieceYCount - 1][pieceXCount - 1]
		drawGrid(grid)
	end,
	function()
		drawBackground()
		local grid = {
			{10, 8, 1, 9},
			{6, 16, 14, 4},
			{12, 11, 5, 15},
			{2, 3, 13, 7}
		}
		drawGrid(grid)
	end,
	function()
		drawBackground()
		local grid = {
			{10, 8, 1, 9},
			{6, 14, 4, 15},
			{12, 11, 5, 7},
			{2, 3, 13, 16}
		}
		drawGrid(grid)
	end,
}
return t
