local Entity = {}

function Entity.new(name, x, y, health, speed, maxSpeed, momentum)
    local startX = x
    local startY = y
    local width = 14
    local height = 14
    return {
        direction = { x = 0, y = 0 },
        x = startX,
        y = startY,
        ax = 0,
        ay = 0,
        vx = 0,
        vy = 0,
        startCoords = { x = startX, y = startY },
        center = { x = startX + width / 2, y = startY + height / 2},
        width = width,
        halfWidth = width / 2,
        height = height,
        halfHeight = height / 2,
        speed = speed,
        maxSpeed = maxSpeed,
        momentum = momentum,
        health = health,
        name = name,
        collisionPoints = {}
    }
end

function Entity.matchPositionToCollider(existingEntity)
    existingEntity.x = existingEntity.collider:getX()
    existingEntity.y = existingEntity.collider:getY()
end

return Entity