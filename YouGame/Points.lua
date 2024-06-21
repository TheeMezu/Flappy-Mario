Points = Class{}

local POINTS_IMAGE = love.graphics.newImage('bird1.png')

function Points:init()
    self.x = math.random(VIRTUAL_WIDTH, VIRTUAL_WIDTH + POINTS_IMAGE:getWidth())
    self.y = math.random(-POINTS_IMAGE:getHeight(), -10) -- Start from above the screen
    self.width = POINTS_IMAGE:getWidth()
    self.height = POINTS_IMAGE:getHeight()

    -- Use class-scoped minSpeed and maxSpeed
    self.fallingSpeed = 40
end

function Points:update(dt)
    self.y = self.y + self.fallingSpeed * dt

    -- Reset object position if it goes below the screen
    if self.y > VIRTUAL_HEIGHT then
        self.y = -self.height -- Reset to the top of the screen
        self.x = math.random(0, VIRTUAL_WIDTH - self.width) -- Randomize horizontal position
        self.fallingSpeed = 40 -- Randomize falling speed
    end
end

function Points:render()
    -- Set color to green
    love.graphics.setColor(0, 255, 0, 255)
    
    -- Draw the green-tinted image
    love.graphics.draw(POINTS_IMAGE, self.x, self.y, 0.5, 0.5)
    
    -- Reset the color back to white for other rendering
    love.graphics.setColor(255, 255, 255, 255)
end
