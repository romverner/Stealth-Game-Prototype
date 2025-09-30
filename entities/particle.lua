local Particle = {}

function Particle.new(x, y, radius, startRadius, frameTime, lifespan)
    return {
        x=x,
        y=y,
        maxRadius=radius,
        currentRadius=startRadius,
        radiusThird=radius * 1/10,
        generatedAt=love.timer.getTime(),
        frameTime=frameTime,
        currentFrameTime=0,
        lastFrame=false,
        lifespan=lifespan,
        expired=false
    }
end

function Particle.track(existingParticle, dt)
    if existingParticle.lastFrame then
        existingParticle.expired = true
        return
    end

    existingParticle.currentFrameTime = existingParticle.currentFrameTime + dt

    if existingParticle.currentFrameTime >= existingParticle.frameTime then
        existingParticle.currentFrameTime = 0
        existingParticle.currentRadius = math.min(existingParticle.currentRadius + existingParticle.radiusThird, existingParticle.maxRadius)

        if existingParticle.currentRadius == existingParticle.maxRadius then
            existingParticle.lastFrame = true
        end

        if love.timer.getTime() - existingParticle.generatedAt > existingParticle.lifespan then
            existingParticle.expired = true
        end
    end
end

function Particle.animate(existingParticle)
    local radiusToDraw = math.min(existingParticle.currentRadius, existingParticle.maxRadius)
    love.graphics.setColor(1,1,1,0.4)
    love.graphics.circle('line', existingParticle.x, existingParticle.y, radiusToDraw)
end

return Particle