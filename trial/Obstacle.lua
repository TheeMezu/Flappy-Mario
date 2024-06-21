Obstacle = Class{}

local OBSTACLE_IMAGE = love.graphics.newImage('pipe.png')
local OBSTACLE_SCROLL = -60

function Obstacle:init()
    self.x = VIRTUAL_WIDTH + 64
    self.y = math.random(VIRTUAL_HEIGHT - 150, VIRTUAL_HEIGHT - 50)

    self.width = OBSTACLE_IMAGE:getWidth()
    self.height = OBSTACLE_IMAGE:getHeight()

end

function Obstacle:update(dt)
    self.x = self.x + OBSTACLE_SCROLL * dt
end

function Obstacle:render()
    love.graphics.draw(OBSTACLE_IMAGE, self.x, self.y)
end