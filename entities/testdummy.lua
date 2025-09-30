Entity = require 'entities.entity'

TestDummy = Entity.new('dummy', 75, 75, 999, 8, 35, 1)

TestDummy.collider = world:newBSGRectangleCollider(TestDummy.x, TestDummy.y, TestDummy.width, TestDummy.height, 3)
TestDummy.collider:setFixedRotation(true)

TestDummy.facing = { x=1, y = 0 }
TestDummy.visionDistance = 75
TestDummy.detectionTime = 0.5
TestDummy.detectionLevel = 0
TestDummy.patrolPoints = {{x=75,y=75,name='patrol'},{x=350,y=75,name='patrol'}}

TestDummy.attention = nil
TestDummy.inspectTime = 6
TestDummy.angleToAttention = 0
TestDummy.visionArcStartAngle = 0 + math.pi/2.25
TestDummy.visionArcEndAngle = 0 - math.pi/2.25

TestDummy.lastAction = love.timer.getTime()

local function aimVisionAtAttention()
    if TestDummy.attention then
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(TestDummy, TestDummy.attention)
        TestDummy.visionArcStartAngle = angleTo + sectorAngleHalf
        TestDummy.visionArcEndAngle = angleTo - sectorAngleHalf
    end
end

function TestDummy.draw()
    love.graphics.circle('line', TestDummy.x, TestDummy.y, 14)
    aimVisionAtAttention()
    love.graphics.arc('line', TestDummy.x, TestDummy.y, TestDummy.visionDistance, TestDummy.visionArcStartAngle, TestDummy.visionArcEndAngle)
end

function TestDummy.listen()
    if TestDummy.attention then
        if TestDummy.attention.name ~= Player.name then
            for _, particle in ipairs(Player.noiseParticles) do
                if physics.distanceBetweenCoords(TestDummy, particle) <= particle.currentRadius then
                    TestDummy.attention = particle
                    TestDummy.lastAction = love.timer.getTime()
                    break
                end
            end 
        end 
    else
        for _, particle in ipairs(Player.noiseParticles) do
            if physics.distanceBetweenCoords(TestDummy, particle) <= particle.currentRadius then
                TestDummy.attention = particle
                TestDummy.lastAction = love.timer.getTime()
                break
            end
        end 
    end
end

function TestDummy.see(dt)
    -- local visionPoint = { x = TestDummy.facing.x * TestDummy.visionDistance, y = TestDummy.facing.y * TestDummy.visionDistance }
    -- local distanceToVisionPoint = physics.distanceBetweenCoords(TestDummy, visionPoint)
    -- distanceToVisionPoint = math.min(distanceToVisionPoint, TestDummy.visionDistance)
    local playerDetected = trigonometry.isInsideSector(Player, TestDummy, TestDummy.visionArcStartAngle, TestDummy.visionArcEndAngle, TestDummy.visionDistance)
    
    if playerDetected and TestDummy.detectionLevel > TestDummy.detectionTime then
        TestDummy.attention = Player
    elseif playerDetected and TestDummy.detectionLevel > TestDummy.detectionTime / 2 then
        TestDummy.detectionLevel = TestDummy.detectionLevel + dt
        local sectorAngleHalf = math.pi / 2.25
        local angleTo = 0
        angleTo = trigonometry.atanByCoordinates(TestDummy, Player)
        TestDummy.visionArcStartAngle = angleTo + sectorAngleHalf
        TestDummy.visionArcEndAngle = angleTo - sectorAngleHalf
    elseif playerDetected then
        TestDummy.detectionLevel = TestDummy.detectionLevel + dt
    else
        TestDummy.detectionLevel = math.max(TestDummy.detectionLevel - dt, 0)

    end
end

local function scan()

end

local function patrol()
    local nearestPoint = nil
    TestDummy.direction.x = 0
    TestDummy.direction.y = 0

    if love.timer.getTime() - TestDummy.lastAction >= TestDummy.inspectTime then
        for i,point in ipairs(TestDummy.patrolPoints) do
            local distanceTo = physics.distanceBetweenCoords(point, TestDummy)
            
            if distanceTo > 32 then
                if not nearestPoint then
                    nearestPoint = point
                    nearestPoint.distanceTo = distanceTo
                elseif distanceTo < nearestPoint.distanceTo then
                    nearestPoint = point
                    nearestPoint.distanceTo = distanceTo
                end    
            end
        end

        TestDummy.facing.x = nearestPoint.x - TestDummy.x > 0 and 1 or -1
        TestDummy.attention = nearestPoint
        TestDummy.lastAction = love.timer.getTime()
    else
        scan()
    end
end

function TestDummy.setDirection()
    local dummyX = math.floor(TestDummy.x)
    local dummyY = math.floor(TestDummy.y)

    if TestDummy.attention then
        local attentionX = math.floor(TestDummy.attention.x)
        local attentionY = math.floor(TestDummy.attention.y)
        local distanceToAttention = physics.distanceBetweenCoords(TestDummy.attention, TestDummy)

        if distanceToAttention < 16 and TestDummy.attention.name ~= 'player' then
            TestDummy.attention = nil
        end

        if attentionX > dummyX then
            TestDummy.direction.x = 1
        elseif attentionX < dummyX then
            TestDummy.direction.x = -1
        else
            TestDummy.direction.x = 0
        end

        if attentionY > dummyY then
            TestDummy.direction.y = 1
        elseif attentionY < dummyY then
            TestDummy.direction.y = -1
        else
            TestDummy.direction.y = 0
        end
    else
        patrol()
    end
end

function TestDummy.move(dt)
    TestDummy.listen()
    TestDummy.see(dt)
    TestDummy.setDirection()
    
    local normalizedVector = physics.normalizeVector(TestDummy.direction)

    TestDummy.vx = TestDummy.vx + (TestDummy.speed + TestDummy.momentum) * normalizedVector.x * math.abs(normalizedVector.x)
    TestDummy.vy = TestDummy.vy + (TestDummy.speed + TestDummy.momentum) * normalizedVector.y * math.abs(normalizedVector.y)

    TestDummy.vx = TestDummy.vx * 0.92
    TestDummy.vy = TestDummy.vy * 0.92

    if not TestDummy.attention then
        TestDummy.vx = TestDummy.vx * 0.15
        TestDummy.vy = TestDummy.vy * 0.15
    else
        TestDummy.vx = TestDummy.vx * 1.04
        TestDummy.vy = TestDummy.vy * 1.04
    end

    TestDummy.collider:setLinearVelocity(TestDummy.vx, TestDummy.vy)
end

return TestDummy