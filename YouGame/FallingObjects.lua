FallingObjects = Class{}

local FALLINGOBJECT_IMAGE = love.graphics.newImage('mario.png')

-- Define minSpeed and maxSpeed in the class scope
local minSpeed = 20
local maxSpeed = 80

function FallingObjects:init()
    self.x = math.random(VIRTUAL_WIDTH, VIRTUAL_WIDTH + FALLINGOBJECT_IMAGE:getWidth())
    self.y = math.random(-FALLINGOBJECT_IMAGE:getHeight(), -10) -- Start from above the screen
    self.width = FALLINGOBJECT_IMAGE:getWidth()
    self.height = FALLINGOBJECT_IMAGE:getHeight()

    -- Use class-scoped minSpeed and maxSpeed
    self.fallingSpeed = math.random(minSpeed, maxSpeed)
end

function FallingObjects:update(dt)
    self.y = self.y + self.fallingSpeed * dt

    -- Reset object position if it goes below the screen
    if self.y > VIRTUAL_HEIGHT then
        self.y = -self.height -- Reset to the top of the screen
        self.x = math.random(0, VIRTUAL_WIDTH - self.width) -- Randomize horizontal position
        self.fallingSpeed = math.random(minSpeed, maxSpeed) -- Randomize falling speed
    end
end

function FallingObjects:render()
    love.graphics.setColor(255, 0, 0, 255)
    
    -- Draw the tinted image
    love.graphics.draw(FALLINGOBJECT_IMAGE, self.x, self.y, 0, 0.5, 0.5)
    
    -- Reset the color back to white for other rendering
    love.graphics.setColor(255, 255, 255, 255)
end
