function love.load()
    love.window.setMode(640, 384)
    
    wf = require 'libraries.windfield'
    world = wf.newWorld(0, 0)

    sti = require 'libraries.sti'
    gameMap = sti('maps/testmapv2.lua')

    gamera = require 'libraries.camera.gamera'
    cam = gamera.new(0,0,1056,608)
    cam:setWindow(0,0,640,384)
    cam:setScale(1.25)

    physics = require 'logic.physics'
    movement = require 'logic.movement'
    trigonometry = require 'logic.trigonometry'
    Map = require 'logic.map'
    Map.generate(math.ceil(Map.gameWorld[3]/16), math.ceil(Map.gameWorld[4]/16))

    Entity = require 'entities.entity'
    Particle = require 'entities.particle'
    Player = require 'entities.player'
    TestDummy = require 'entities.testdummy'

    walls = {}
    if gameMap.layers['walls'] then
        for i, obj in ipairs(gameMap.layers['walls'].objects) do
            local wall = world:newRectangleCollider(obj.x, obj.y, obj.width, obj.height)
            wall:setType('static')
            table.insert(walls, wall)
        end
    end
end

function love.update(dt)
    Player.move(dt)
    TestDummy.move(dt)
    world:update(dt)
    Entity.matchPositionToCollider(Player)
    Entity.matchPositionToCollider(TestDummy)
    cam:setPosition(Player.x, Player.y)
end

function love.draw()
    cam:draw(drawToCamera)
    love.graphics.print(TestDummy.detectionLevel, 0, 0)
    love.graphics.setColor(1,1,1,1)
    love.graphics.print(math.abs(Player.vx) + math.abs(Player.vy), 0, 15)
end

function love.keypressed(key)
    if key == "lshift" then
        Player.roll()
    end

    if key == 'lalt' then
        Player.crouched = not Player.crouched
        Player.visible = not Player.visible
    end

    if key == '=' then
        
    end
end

function drawToCamera()
    -- Map.draw()
    gameMap:drawLayer(gameMap.layers['tile'])
    Player.draw()
    TestDummy.draw()
    love.graphics.setColor(1,1,1)
    love.graphics.circle('line', TestDummy.x, TestDummy.y, 1)
    love.graphics.circle('line', Player.x, Player.y, 1)
    -- world:draw()
end