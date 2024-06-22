Spaceship = Class{}

function Spaceship:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - 16
    self.y = VIRTUAL_HEIGHT - 50
    self.dx = 0
    self.dy = 0

    self.facingleft = false
end


function Spaceship:collides(obstacle)
    if (self.x + 2) + (self.width - 4) >= obstacle.x and self.x + 2 <= obstacle.x + obstacle.width then
        if (self.y + 2) + (self.height - 4) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height then
            return true
        end
    end
end

function Spaceship:collidesMario(obstacle)
    if (self.x + 2) + (self.width - 4) >= obstacle.x and self.x + 2 <= obstacle.x + obstacle.width / 2 then
        if (self.y + 2) + (self.height - 4) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height / 2 then
            return true
        end
    end
end

function Spaceship:PointsCollection(obstacle)
    if (self.x + 2) + (self.width - 4) >= obstacle.x and self.x + 2 <= obstacle.x + obstacle.width / 2 then
        if (self.y + 2) + (self.height - 4) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height / 2 then
            return true
        end
    end
end

function Spaceship:Extra(obstacle)
    if (self.x + 2) + (self.width /2) >= obstacle.x and self.x + 2 <= obstacle.x + obstacle.width / 2 then
        if (self.y + 2) + (self.height /2) >= obstacle.y and self.y + 2 <= obstacle.y + obstacle.height / 2  then
            return true
        end
    end
end


function Spaceship:update(dt)
    local acceleration = 100  -- Adjust acceleration value 
    local friction = 80  -- Adjust friction value 
    local gravity = 50 -- Adjust gravity value 

    -- Apply acceleration based on keyboard input
    if love.keyboard.isDown('left') then
        self.dx = self.dx - 0.5 - acceleration * dt
        self.facingleft = true
    elseif love.keyboard.isDown('right') then
        self.dx = self.dx + 0.5 + acceleration * dt
        self.facingleft = false
    elseif love.keyboard.isDown('down') then
        self.dy = acceleration 
    elseif love.keyboard.isDown('space') then 
        self.dy = - 100 -- Adjust jump strength 
        sounds['jump']:play()
    else
        -- Apply friction when not pressing any movement keys
        if self.dx > 0 then
            self.dx = math.max(0, self.dx - friction * dt)
        elseif self.dx < 0 then
            self.dx = math.min(0, self.dx + friction * dt)
        end
    end

    -- Apply gravity
    self.dy = self.dy + gravity * dt

    -- Update position based on velocity
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt 

    -- Adjust based on the screen width (VIRTUAL_WIDTH) and height (VIRTUAL_HEIGHT)
    self.x = math.max(0, math.min(self.x, VIRTUAL_WIDTH - self.width))
    self.y = math.max(0, math.min(self.y, VIRTUAL_HEIGHT - self.height * 1.7))
end



function Spaceship:render()
    -- Your rendering code here
    if self.facingleft then
        -- Flip the sprite horizontally when facing left
        love.graphics.draw(self.image, self.x + self.width, self.y, 0, -1, 1)
    else
        -- Draw the sprite normally when facing right
        love.graphics.draw(self.image, self.x, self.y)
    end
end
