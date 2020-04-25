require 'src/Dependencies'

paused = false

function love.load()
	love.graphics.setDefaultFilter('nearest', 'nearest')
	
	love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
		fullscreen = false,
		resizable = false,
		vsync = true
	})
	
	board = Board()

	-- initialize mouse input table
	love.mouse.buttonsPressed = {}
end

--Callback function triggered when a mouse button is pressed.
function love.mousepressed(x, y, button)
	love.mouse.buttonsPressed[button] = true
end

function love.mouse.wasPressed(button)
	return love.mouse.buttonsPressed[button]
end

function love.keypressed(key)
	if key == 'escape' then
		love.event.quit()
	elseif key == 'space' then
		if paused then
			paused = false
		else
			paused = true
		end
	end
end

function love.update(dt)
	board:update(dt)
	love.mouse.buttonsPressed = {}
end

function love.draw()
	board:render()
end