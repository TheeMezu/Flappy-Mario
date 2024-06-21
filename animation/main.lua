function love.load()
    anim8 = require 'libraries/anim8'
    love.graphics.setDefaultFilter("nearest", "nearest")

    coin = {}
    coin.x = 400
    coin.y = 300
    coin.rotationSpeed = 5
    
    coin.spriteSheet = love.graphics.newImage('sprites/coin-sheet.jpg')
    coin.grid = anim8.newGrid(32, 32, coin.spriteSheet:getWidth(), coin.spriteSheet:getHeight())

    coin.animations = {}

    coin.animations.rotation1 = anim8.newAnimation(coin.grid('1-10', 1), coin.rotationSpeed)
    coin.animations.rotation2 = anim8.newAnimation(coin.grid('2-8', 2), coin.rotationSpeed)

    coin.anim = coin.animations.rotation1

    background = love.graphics.newImage('sprites/background.png')
end

function love.update(dt)
    coin.anim:update(dt)
end

function love.draw()
    love.graphics.draw(background, 0, 0)
    coin.anim:draw(coin.spriteSheet, coin.x, coin.y, nil, 2)
end
