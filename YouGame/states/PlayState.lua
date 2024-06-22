PlayState = Class{__includes = BaseState}

function PlayState:init()
    self.spaceship = Spaceship()
    self.obstacle_list = {}
    self.fallingobject_list = {} -- Initialize list for falling objects
    self.points_list = {} -- Initialize list for falling objects
    self.bulb_list = {}
    self.timer = 0
    self.timer2 = 0
    self.timer3 = 0
    self.timer4 = 0
    self.score = 0
end

function PlayState:update(dt)
    -- update timer for obstacle spawning
    self.timer = self.timer + dt

    -- spawn a new obstacle every second and a half
    if self.timer > 5 then
        table.insert(self.obstacle_list, Obstacle())
        self.timer = 0
    end

    -- update position of obstacles and falling objects
    for k, obstacle in pairs(self.obstacle_list) do
        obstacle:update(dt)
        if obstacle.x < -obstacle.width then
            table.remove(self.obstacle_list, k)
        end
    end

    self.timer2 = self.timer2 + dt
    -- spawn falling objects randomly
    if self.timer2 > 4.5 then
        table.insert(self.fallingobject_list, FallingObjects())
        self.timer2 = 0
    end

    -- update position of falling objects
    for k, fallingobject in pairs(self.fallingobject_list) do
        fallingobject:update(dt)
        if fallingobject.y > VIRTUAL_HEIGHT then
            table.remove(self.fallingobject_list, k)
        end
    end

    -- update spaceship
    self.spaceship:update(dt)

    -- check for collisions between spaceship and obstacles
    for k, obstacle in pairs(self.obstacle_list) do
        if self.spaceship:collides(obstacle) then
            -- Handle collision (game over logic)
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', { score = self.score })
        end
    end

    -- check for collisions between spaceship and falling objects
    for k, fallingobject in pairs(self.fallingobject_list) do
        if self.spaceship:collidesMario(fallingobject) then
            -- Handle collision (game over logic)
            sounds['explosion']:play()
            sounds['hurt']:play()
            gStateMachine:change('score', { score = self.score })
        end
    end



    self.timer3 = self.timer3 + dt
    -- spawn points
    if self.timer3 > 5 then
        table.insert(self.points_list, Points())
        self.timer3 = 0  -- Adjust the timer variable
    end

    -- update position of points individually
    for k, point in pairs(self.points_list) do
        point:update(dt)  -- Update each point individually
        if point.y > VIRTUAL_HEIGHT then
            table.remove(self.points_list, k)
        end
    end

    -- Check for collisions between the spaceship and the scoring points
    for k, points in pairs(self.points_list) do
        if self.spaceship:PointsCollection(points) then
            -- Remove the collided scoring point from the list
            table.remove(self.points_list, k)

            -- Award points
            self.score = self.score + 1
            sounds['score']:play()
    
        end
    end


    -- Spawn bulbs
    self.timer4 = self.timer4 + dt
    if self.timer4 > 8 then
        table.insert(self.bulb_list, Bulb()) 
        self.timer4 = 0
    end

    -- Update bulbs
    for k, bulb in pairs(self.bulb_list) do
        bulb:update(dt)
        -- Remove bulbs that have disappeared
        if bulb.y > VIRTUAL_HEIGHT then
            table.remove(self.points_list, k)
        end

    end

    -- Handle collisions between spaceship and bulbs
    for k, bulb in pairs(self.bulb_list) do
        if self.spaceship:Extra(bulb) then
            -- Remove the collided bulb from the list
            table.remove(self.bulb_list, k)

            -- Award points
            self.score = self.score + 5
            sounds['score']:play()

        end
    end

end

function PlayState:render()
    -- Render obstacles
    for k, obstacle in pairs(self.obstacle_list) do
        obstacle:render()
    end

    -- Render falling objects
    for k, fallingobject in pairs(self.fallingobject_list) do
        fallingobject:render()
    end

    for k, points in pairs(self.points_list) do
        points:render()
    end
    for k, bulb in pairs(self.bulb_list) do
        bulb:render()
    end

    -- Render spaceship
    self.spaceship:render()

    -- Render score
    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' .. tostring(self.score), 8, 8)
end

function PlayState:enter()
    -- Reset score and timer when entering play state
    self.score = 0
    self.timer = 0
end
