Entity = require 'entities.entity'

Player = Entity.new('player', 20, 20, 25, 10, 20, 3)

Player.collider = world:newBSGRectangleCollider(Player.x, Player.y, Player.width, Player.height, 3)
-- Player.collider:setFixedRotation(true)

-- ACTIONS
Player.crouched = false
Player.crouchSpeed = 0.55

Player.momentum = 0
Player.rollBoost = 400
Player.rolledLast = nil
Player.rollCooldown = 0.75

Player.noiseParticles = {}
Player.particleTimer = 0
Player.particleGenerationTime = 0.5

Player.visible = true

local function generateAndTrackParticles(dt)
    for i, noiseParticle in ipairs(Player.noiseParticles) do
        Particle.track(noiseParticle, dt)
    end

    Player.particleTimer = Player.particleTimer + dt
    local generationTime = Player.crouched and Player.particleGenerationTime+ Player.crouchSpeed or Player.particleGenerationTime
    if Player.particleTimer >= generationTime then
        local noiseRadius = (math.abs(Player.vx) + math.abs(Player.vy)) * 0.6
        table.insert(Player.noiseParticles, Particle.new(Player.x, Player.y, noiseRadius, 3, 0.1, 10))
        Player.particleTimer = 0
    end
end

function Player.roll()
    if not Player.rolledLast then
        Player.momentum = Player.rollBoost
        Player.rolledLast = love.timer.getTime()
    elseif love.timer.getTime() - Player.rolledLast >= Player.rollCooldown then
        Player.momentum = Player.rollBoost
        Player.rolledLast = love.timer.getTime()
    end
end

function Player.draw()
    for i, noiseParticle in ipairs(Player.noiseParticles) do
        if noiseParticle.expired then
            table.remove(Player.noiseParticles, i)
        else
            Particle.animate(noiseParticle)
        end
    end
    love.graphics.setColor(1, 0.5, 0, 1)
    love.graphics.rectangle('line', Player.x - Player.width / 2, Player.y - Player.height / 2, Player.width, Player.height)
end

function Player.move(dt)
    Player.direction = movement.getKeyboardDirectionVector()
    local normalizedVector = physics.normalizeVector(Player.direction)

    Player.vx = Player.vx + (Player.speed + Player.momentum) * (Player.crouched and Player.crouchSpeed or 1) * normalizedVector.x * math.abs(normalizedVector.x)
    Player.vy = Player.vy + (Player.speed + Player.momentum) * (Player.crouched and Player.crouchSpeed or 1) * normalizedVector.y * math.abs(normalizedVector.y)

    Player.vx = Player.vx * 0.92 --+ Player.momentum * Player.direction.x
    Player.vy = Player.vy * 0.92 --+ Player.momentum * Player.direction.y

    Player.collider:setLinearVelocity(Player.vx, Player.vy)
    Player.momentum = 0

    generateAndTrackParticles(dt)
end

return Player