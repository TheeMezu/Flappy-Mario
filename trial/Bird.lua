--[[
    Bird Class
    Author: Colton Ogden
    cogden@cs50.harvard.edu

    The Bird is what we control in the game via clicking or the space bar; whenever we press either,
    the bird will flap and go up a little bit, where it will then be affected by gravity. If the bird hits
    the ground or a pipe, the game is over.
]]

Bird = Class{}

local GRAVITY = 20

function Bird:init()
    self.image = love.graphics.newImage('bird.png')
    self.width = self.image:getWidth()
    self.height = self.image:getHeight()

    self.x = VIRTUAL_WIDTH / 2 - 16
    self.y = VIRTUAL_HEIGHT - 50
    self.dx = 0
    self.dy = 0

    self.facingleft = false
end

--[[
    AABB collision that expects a pipe, which will have an X and Y and reference
    global pipe width and height values.
]]

function Bird:collides(pipe)
    if (self.x + 2) + (self.width - 4) >= pipe.x and self.x + 2 <= pipe.x + pipe.width then
        if (self.y + 2) + (self.height - 4) >= pipe.y and self.y + 2 <= pipe.y + pipe.height then
            return true
        end
    end
end


function Bird:update(dt)
    local acceleration = 100  -- Adjust acceleration value as needed
    local friction = 80  -- Adjust friction value as needed
    local gravity = 50 -- Adjust gravity value as needed

    -- Apply acceleration based on keyboard input
    if love.keyboard.isDown('left') then
        self.dx = self.dx - 0.5 - acceleration * dt
        self.facingleft = true
    elseif love.keyboard.isDown('right') then
        self.dx = self.dx + 0.5 + acceleration * dt
        self.facingleft = false
    elseif love.keyboard.isDown('down') then
        self.dy = acceleration 
    elseif love.keyboard.isDown('space') then -- 'space', not 'spacebar'
        self.dy = - 100 -- Adjust jump strength as needed
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
    self.y = self.y + self.dy * dt -- Update y position based on vertical velocity

    -- Optionally, you can add boundaries to keep the spaceship within the screen
    -- Adjust as needed based on the screen width (VIRTUAL_WIDTH) and height (VIRTUAL_HEIGHT)
    self.x = math.max(0, math.min(self.x, VIRTUAL_WIDTH - self.width))
    self.y = math.max(0, math.min(self.y, VIRTUAL_HEIGHT - self.height * 1.7))
end



function Bird:render()
    -- Your rendering code here
    if self.facingleft then
        -- Flip the sprite horizontally when facing left
        love.graphics.draw(self.image, self.x + self.width, self.y, 0, -1, 1)
    else
        -- Draw the sprite normally when facing right
        love.graphics.draw(self.image, self.x, self.y)
    end
end