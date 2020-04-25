Board = Class{}
localtime = 0 

function Board:init()
	self.board = {}
	self.boardAux = {}
	self:createBoards()
end

function Board:createBoards()
	for blockY = 1, WINDOW_HEIGHT / BLOCK_SIZE do
		table.insert(self.board, {})
		table.insert(self.boardAux, {})
		for blockX = 1, WINDOW_WIDTH / BLOCK_SIZE do
			table.insert(self.board[blockY], Block(blockX * BLOCK_SIZE, blockY * BLOCK_SIZE))
			table.insert(self.boardAux[blockY], Block(blockX * BLOCK_SIZE, blockY * BLOCK_SIZE))
		end
	end
end

function Board:update(dt)
	localtime = localtime + dt

	--revival or kill block with click
	if love.mouse.wasPressed(1) then
		local x, y = love.mouse.getPosition()

		local x = math.floor(x / BLOCK_SIZE) + 1
		local y = math.floor(y / BLOCK_SIZE) + 1

		if self.board[y][x]:isLive() == 1 then
			self.board[y][x].live = 0
		else
			self.board[y][x].live = 1
		end
	end

	if paused == false then
		--Update board every 0.1 seconds
		if localtime > 0.1 then

			--Apply rules to calculate the new board condition in the aux board
			for y = 1, #self.board do
				for x = 1, #self.board[1] do
					self:rules(y, x)
				end
			end

			--Copy the aux board in the board game to update 
			for y = 1, #self.board do
				for x = 1, #self.board[1] do
					self.board[y][x].live = self.boardAux[y][x].live
				end
			end

			--Restart time
			localtime = 0
		end
	end
end

function Board:render()
	for y = 1, #self.board do
		for x = 1, #self.board[1] do
			self.board[y][x]:render()
		end
	end
end

--Apply rules in the auxiliar board
function Board:rules(y, x)
	local neighbors =  self:n_neighbors_live(y, x)
	if  (neighbors == 3 ) and self.board[y][x]:isLive() == 0 then
		self.boardAux[y][x].live = 1
	elseif (neighbors == 3 or neighbors == 2) and self.board[y][x]:isLive() == 1 then
		self.boardAux[y][x].live = 1
	else
		self.boardAux[y][x].live = 0
	end
end

--Return the sum of living neighbors 
function Board:n_neighbors_live(y, x)
	return 
		(self.board[calcModuleX(y - 1, 'y')][calcModuleX(x - 1, 'x')]:isLive() +
		self.board[calcModuleX(y - 1, 'y')][calcModuleX(x, 'x')]:isLive() +
		self.board[calcModuleX(y - 1, 'y')][calcModuleX(x + 1, 'x')]:isLive() +

		self.board[calcModuleX(y, 'y')][calcModuleX(x - 1, 'x')]:isLive() +
		--self.board[calcModuleX(y, 'y')][calcModuleX(x, 'x')]:isLive() +
		self.board[calcModuleX(y, 'y')][calcModuleX(x + 1, 'x')]:isLive() +

		self.board[calcModuleX(y + 1, 'y')][calcModuleX(x - 1, 'x')]:isLive() +
		self.board[calcModuleX(y + 1, 'y')][calcModuleX(x, 'x')]:isLive() +
		self.board[calcModuleX(y + 1, 'y')][calcModuleX(x + 1, 'x')]:isLive())
end

--Function that returns the opposite end of the board in case the neighbor goes out of bounds
function calcModuleX(n, xy)
	if n == 0 then
		if xy == 'x' then
			return BLOCKS_IN_ROW
		else
			return BLOCKS_IN_COLUMN
		end
	elseif n > BLOCKS_IN_ROW and xy == 'x' or n > BLOCKS_IN_COLUMN and xy == 'y' then
			return 1
	else
		return n 
	end
end

function Board:GenerateShip(y,x)
	self.board[y+1][x].live = 1
	self.board[y+2][x].live = 1
	self.board[y+1][x+1].live = 1
	self.board[y+2][x+1].live = 1
	self.board[y+3][x+1].live = 1
	self.board[y+1][x+2].live = 1
	self.board[y+2][x+2].live = 1
	self.board[y+3][x+2].live = 1
	self.board[y][x+3].live = 1
	self.board[y+2][x+3].live = 1
	self.board[y+3][x+3].live = 1
	self.board[y][x+4].live = 1
	self.board[y+1][x+4].live = 1
	self.board[y+2][x+4].live = 1
	self.board[y+1][x+5].live = 1
end

function Board:GenerateGlider(y,x)
	self.board[y][x+1].live = 1
	self.board[y+1][x+2].live = 1
	self.board[y+2][x].live = 1
	self.board[y+2][x+1].live = 1
	self.board[y+2][x+2].live = 1
end