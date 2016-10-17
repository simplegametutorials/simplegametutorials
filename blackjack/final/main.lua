function love.load()
	love.graphics.setBackgroundColor(255, 255, 255)

	images = {}
	for nameIndex, name in ipairs({
		1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13,
		'pip_heart', 'pip_diamond', 'pip_club', 'pip_spade',
		'mini_heart', 'mini_diamond', 'mini_club', 'mini_spade',
		'card', 'card_face_down',
		'face_jack', 'face_queen', 'face_king',
	}) do
		images[name] = love.graphics.newImage('images/'..name..'.png')
	end

	function takeCard(hand)
		table.insert(hand, table.remove(deck, love.math.random(#deck)))
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

	buttonY = 230
	buttonHeight = 25

	buttonHitX = 10
	buttonHitWidth = 53

	buttonStandX = 70
	buttonStandWidth = 53

	buttonPlayAgainX = 10
	buttonPlayAgainWidth = 113

	function isMouseInButton(buttonX, buttonWidth)
		return love.mouse.getX() >= buttonX
		and love.mouse.getX() < buttonX + buttonWidth
		and love.mouse.getY() >= buttonY
		and love.mouse.getY() < buttonY + buttonHeight
	end

	function reset()
		deck = {}
		for suitIndex, suit in ipairs({'club', 'diamond', 'heart', 'spade'}) do
			for rank = 1, 13 do
				table.insert(deck, {suit = suit, rank = rank})
			end
		end

		playerHand = {}
		takeCard(playerHand)
		takeCard(playerHand)

		dealerHand = {}
		takeCard(dealerHand)
		takeCard(dealerHand)

		roundOver = false
	end

	reset()
end

function love.draw()
	local output = {}

	table.insert(output, 'Player hand:')
	for cardIndex, card in ipairs(playerHand) do
		table.insert(output, 'suit: '..card.suit..', rank: '..card.rank)
	end

	love.graphics.print(table.concat(output, '\n'), 15, 15)

	if roundOver then
		table.insert(output, '')

		local function hasHandWon(thisHand, otherHand)
			return getTotal(thisHand) <= 21
			and (
				getTotal(otherHand) > 21
				or getTotal(thisHand) > getTotal(otherHand)
			)
		end

		if hasHandWon(playerHand, dealerHand) then
			table.insert(output, 'Player wins')
		elseif hasHandWon(dealerHand, playerHand) then
			table.insert(output, 'Dealer wins')
		else
			table.insert(output, 'Draw')
		end
	end

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

		local function drawCorner(image, offsetX, offsetY)
			love.graphics.draw(
				image,
				x + offsetX,
				y + offsetY
			)
			love.graphics.draw(
				image,
				x + cardWidth - offsetX,
				y + cardHeight - offsetY,
				0,
				-1
			)
		end

		drawCorner(images[card.rank], 3, 4)
		drawCorner(images['mini_'..card.suit], 3, 14)

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

			local xLeft = 11
			local xMid = 21
			local yTop = 7
			local yThird = 19
			local yQtr = 23
			local yMid = 31

			if card.rank == 1 then
				drawPip(xMid, yMid)
			elseif card.rank == 2 then
				drawPip(xMid, yTop, false, true)
			elseif card.rank == 3 then
				drawPip(xMid, yTop, false, true)
				drawPip(xMid, yMid)
			elseif card.rank == 4 then
				drawPip(xLeft, yTop, true, true)
			elseif card.rank == 5 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xMid, yMid)
			elseif card.rank == 6 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
			elseif card.rank == 7 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
				drawPip(xMid, yThird)
			elseif card.rank == 8 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yMid, true)
				drawPip(xMid, yThird, false, true)
			elseif card.rank == 9 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yQtr, true, true)
				drawPip(xMid, yMid)
			elseif card.rank == 10 then
				drawPip(xLeft, yTop, true, true)
				drawPip(xLeft, yQtr, true, true)
				drawPip(xMid, 16, false, true)
			end
		end
	end

	local cardSpacing = 60
	local marginX = 10

	for cardIndex, card in ipairs(dealerHand) do
		local dealerMarginY = 30
		if not roundOver and cardIndex == 1 then
			love.graphics.draw(images.card_face_down, marginX, dealerMarginY)
		else
			drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, dealerMarginY)
		end
	end

	for cardIndex, card in ipairs(playerHand) do
		drawCard(card, ((cardIndex - 1) * cardSpacing) + marginX, 140)
	end

	love.graphics.setColor(0, 0, 0)

	if roundOver then
		love.graphics.print('Total: '..getTotal(dealerHand), marginX, 10)
	else
		love.graphics.print('Total: ?', marginX, 10)
	end

	love.graphics.print('Total: '..getTotal(playerHand), marginX, 120)

	if roundOver then
		local function hasHandWon(thisHand, otherHand)
			return getTotal(thisHand) <= 21
			and (
				getTotal(otherHand) > 21
				or getTotal(thisHand) > getTotal(otherHand)
			)
		end

		local function drawWinner(message)
			love.graphics.print(message, marginX, 268)
		end

		if hasHandWon(playerHand, dealerHand) then
			drawWinner('Player wins')
		elseif hasHandWon(dealerHand, playerHand) then
			drawWinner('Dealer wins')
		else
			drawWinner('Draw')
		end
	end

	local function drawButton(text, buttonX, buttonWidth, textOffsetX)
		local buttonY = 230
		local buttonHeight = 25

		if love.mouse.getX() >= buttonX
		and love.mouse.getX() < buttonX + buttonWidth
		and love.mouse.getY() >= buttonY
		and love.mouse.getY() < buttonY + buttonHeight then
			love.graphics.setColor(255, 202, 75)
		else
			love.graphics.setColor(255, 127, 57)
		end
		love.graphics.rectangle('fill', buttonX, buttonY, buttonWidth, buttonHeight)
		love.graphics.setColor(255, 255, 255)
		love.graphics.print(text, buttonX + textOffsetX, buttonY + 6)
	end

	if roundOver then
		drawButton('Play again', buttonPlayAgainX, buttonPlayAgainWidth, 24)
	else
		drawButton('Hit!', buttonHitX, buttonHitWidth, 16)
		drawButton('Stand', buttonStandX, buttonStandWidth, 8)
	end
end

function love.mousereleased()
	if not roundOver then
		if isMouseInButton(buttonHitX, buttonHitWidth) then
			takeCard(playerHand)
			if getTotal(playerHand) > 21 then
				roundOver = true
			end
		elseif isMouseInButton(buttonStandX, buttonStandWidth) then
			roundOver = true
		end

		if roundOver then
			while getTotal(dealerHand) < 17 do
				takeCard(dealerHand)
			end
		end
	elseif isMouseInButton(buttonPlayAgainX, buttonY, buttonPlayAgainWidth, buttonHeight) then
		reset()
	end
end
