push = require 'push'
Class = require 'class'
require 'Spaceship'
require 'Obstacle'
require 'FallingObjects'
require 'Points'
require 'Bulb'
require 'StateMachine'
require 'states/BaseState'
require 'states/CountdownState'
require 'states/PlayState'
require 'states/ScoreState'
require 'states/TitleScreenState'

-- Physical screen dimensions
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution dimensions
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Background image
local background = love.graphics.newImage('background.png')
local backgroundMotion = 0
local ground = love.graphics.newImage('ground.png')
local groundMotion = 0
local BACKGROUND_SCROLL_SPEED = 30
local GROUND_SCROLL_SPEED = 60
local BACKGROUND_LOOPING_POINT = 413

local spaceship = Spaceship()
local obstacle = Obstacle()
local points = Points()
local bulb = Bulb()
local obstacle_list = {}
local bulb_list = {}
local spawnTimer = 0

local fallingobject_list = {}
local spawnTimer_falling = 0
local scrollPause = true

function love.load()
    -- Initialize our nearest-neighbor filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- app window title
    love.window.setTitle('Flappy Mario')

    -- initialize our nice-looking retro text fonts
    smallFont = love.graphics.newFont('font.ttf', 8)
    mediumFont = love.graphics.newFont('flappy.ttf', 14)
    flappyFont = love.graphics.newFont('flappy.ttf', 28)
    hugeFont = love.graphics.newFont('flappy.ttf', 56)
    love.graphics.setFont(flappyFont)

    sounds = {
        ['jump'] = love.audio.newSource('jump.wav', 'static'),
        ['explosion'] = love.audio.newSource('explosion.wav', 'static'),
        ['hurt'] = love.audio.newSource('hurt.wav', 'static'),
        ['score'] = love.audio.newSource('score.wav', 'static'),

        -- https://freesound.org/people/xsgianni/sounds/388079/
        ['music'] = love.audio.newSource('marios_way.mp3', 'static')
    }

    -- kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()


    -- Initialize our virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- initialize state machine with all state-returning functions
    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end,
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end,
        ['score'] = function() return ScoreState() end
    }
    gStateMachine:change('title')

    -- Initialize input table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.keypressed(key)
    -- Add to our table of keys pressed this frame
    love.keyboard.keysPressed[key] = true

    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end

function love.update(dt)

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
    backgroundMotion = (backgroundMotion + BACKGROUND_SCROLL_SPEED * dt) 
        % BACKGROUND_LOOPING_POINT
    groundMotion = (groundMotion + GROUND_SCROLL_SPEED * dt) 
        % VIRTUAL_WIDTH

        gStateMachine:update(dt)

    love.keyboard.keysPressed = {}
end

function love.draw()
    push:start()


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

    love.graphics.draw(background, -backgroundMotion, 0)

    gStateMachine:render()

    love.graphics.draw(ground, -groundMotion, VIRTUAL_HEIGHT - 16)

    push:finish()
end
