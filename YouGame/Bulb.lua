-- Define the Bulb class
Bulb = Class{}
local BULB_IMAGE = love.graphics.newImage('coin.png')

function Bulb:init()
    self.width = BULB_IMAGE:getWidth()
    self.height = BULB_IMAGE:getHeight()
    local min_y = VIRTUAL_HEIGHT - self.height + 80  -- Adjust the value for more space
    local max_y = VIRTUAL_HEIGHT - self.height / 2
    self.x = VIRTUAL_WIDTH + 64
    self.y = math.random(min_y, max_y)
end


function Bulb:update(dt)
    self.x = self.x  -60 * dt
end

function Bulb:render()
    love.graphics.draw(BULB_IMAGE, self.x, self.y, 0 ,0.1,0.1) -- Draw the bulb image
end
