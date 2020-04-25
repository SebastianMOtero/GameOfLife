Block = Class{}

function Block:init(x, y)
	self.x = x - BLOCK_SIZE
	self.y = y - BLOCK_SIZE
	self.size = BLOCK_SIZE
	self.live = 0
end

function Block:render()
	if self.live == 1 then
		love.graphics.rectangle('fill', self.x, self.y, self.size, self.size)
	else
		love.graphics.rectangle('line', self.x, self.y, self.size, self.size)
	end
end

function Block:isLive()
	return self.live
end