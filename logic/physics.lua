physics = {}

function physics.get2DVector()
    return { x = 0, y = 0 }
end

function physics.normalizeVector(vectorToNormalize)
    local length = math.sqrt( vectorToNormalize.x^2 + vectorToNormalize.y^2 )
    
    if length > 0 then
        vectorToNormalize.x = vectorToNormalize.x / length
        vectorToNormalize.y = vectorToNormalize.y / length
    end

    return vectorToNormalize
end

function physics.reverseVectorX(vectorToReverse)
    if vectorToReverse.x == 1 then
        vectorToReverse.x = -1
    elseif vectorToReverse.x == -1 then
        vectorToReverse.x = 1
    end

    return vectorToReverse
end

function physics.distanceBetweenCoords(coords1, coords2)
    return math.sqrt( (coords2.x - coords1.x)^2 + (coords2.y - coords1.y)^2 )
end

function physics.getAcceleration(dt, vector, speed, momentum)
    local ax, ay = 0, 0
    ax = vector.x * (speed * dt + momentum) * math.abs(vector.x)
    ay = vector.y * (speed * dt + momentum) * math.abs(vector.y)
    return ax, ay
end

return physics