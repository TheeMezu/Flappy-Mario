--[[
    GD50
    Flappy Bird Remake

    bird3
    "The Gravity Update"

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    A mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple 
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping 
    the screen, making the player's bird avatar flap its wings and move upwards slightly. 
    A variant of popular games like "Helicopter Game" that floated around the internet
    for years prior. Illustrates some of the most basic procedural generation of game
    levels possible as by having pipes stick out of the ground by varying amounts, acting
    as an infinitely generated obstacle course for the player.
]]

-- virtual resolution handling library
push = require 'push'

-- classic OOP class library
Class = require 'class'

-- bird class we've written
require 'Bird'

require 'Obstacle'

-- physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- background image and starting scroll location (X axis)
local background = love.graphics.newImage('background.png')
local backgroundScroll = 0

-- ground image and starting scroll location (X axis)
local ground = love.graphics.newImage('ground.png')
local groundScroll = 0

-- speed at which we should scroll our images, scaled by dt
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local groundMotion = 0
local backgroundMotion = 0
-- point at which we should loop our background back to X 0
local BACKGROUND_LOOPING_POINT = 413

-- our bird sprite
local bird = Bird()
local obstacle = Obstacle()
local obstacle_list = {}
local spawnTimer = 0

local scrollPause = true
function love.load()
    -- initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Fifty Bird')

    -- initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.update(dt)

    if scrollPause then
        backgroundMotion = (backgroundMotion + BACKGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT
        groundMotion = (groundMotion + GROUND_SCROLL_SPEED * dt) 
            % VIRTUAL_WIDTH

        -- Obstacle spawning logic
        spawnTimer = spawnTimer + dt
        if spawnTimer > 5 then
            table.insert(obstacle_list, Obstacle())
            spawnTimer = 0
        end

        -- Spaceship collision check and obstacle updates
        bird:update(dt)
        for l,obstacle in pairs(obstacle_list) do
            if bird:collides(obstacle) then
                scrollPause = false
            end
        end

        for k, obstacle in pairs(obstacle_list) do 
            obstacle:update(dt)
            if obstacle.x < - obstacle.width then
                table.remove(obstacle_list,k)
            end
        end
    end
end

function love.draw()
    push:start()

    -- draw the background at the negative looping point
    love.graphics.draw(background, -backgroundScroll, 0)

    -- draw the ground on top of the background, toward the bottom of the screen,
    -- at its negative looping point
    love.graphics.draw(ground, -groundScroll, VIRTUAL_HEIGHT - 16)

    -- render our bird to the screen using its own render logic
    bird:render()

    love.graphics.draw(background, -backgroundMotion, 0)
    for k, obstacle in pairs(obstacle_list) do 
        obstacle:render()
    end
    love.graphics.draw(ground, -groundMotion, VIRTUAL_HEIGHT - 16)
    bird:render()
    
    push:finish()
end


    --[[
    if scrollPause then
        backgroundMotion = (backgroundMotion + BACKGROUND_SCROLL_SPEED * dt) 
            % BACKGROUND_LOOPING_POINT
        groundMotion = (groundMotion + GROUND_SCROLL_SPEED * dt) 
            % VIRTUAL_WIDTH

        -- Obstacle spawning logic
        spawnTimer = spawnTimer + dt
        if spawnTimer > 5 then
            table.insert(obstacle_list, Obstacle())
            spawnTimer = 0
        end

        -- Falling object spawning logic
        spawnTimer_falling = spawnTimer_falling + dt
        if spawnTimer_falling > 4.5 then
            table.insert(fallingobject_list, FallingObjects()) -- Corrected instantiation
            spawnTimer_falling = 0
        end

        -- Spaceship collision check and obstacle updates
        spaceship:update(dt)
        for l,obstacle in pairs(obstacle_list) do
            if spaceship:collides(obstacle) then
                scrollPause = false
            end
        end

        for k, obstacle in pairs(obstacle_list) do 
            obstacle:update(dt)
            if obstacle.x < - obstacle.width then
                table.remove(obstacle_list,k)
            end
        end

        -- Falling object updates
        for l,fallingobject in pairs(fallingobject_list) do
            if spaceship:collidesMario(fallingobject) then
                scrollPause = false
            end
        end

        for k, fallingobject in pairs(fallingobject_list) do 
            fallingobject:update(dt)
            if fallingobject.y < - fallingobject.height then
                table.remove(fallingobject_list,k)
            end
        end
    end
    ]]


        -- Render the character and the background
    --[[
    love.graphics.draw(background, -backgroundMotion, 0)
    for k, obstacle in pairs(obstacle_list) do 
        obstacle:render()
    end

    for k, fallingobject in pairs(fallingobject_list) do 
        fallingobject:render()
    end
    love.graphics.draw(ground, -groundMotion, VIRTUAL_HEIGHT - 16)
    spaceship:render()
    ]]