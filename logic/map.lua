Map = {}
Map.tiles = {}
Map.size = {}
Map.size.index = {}

Map.gameWorld = {cam:getWorld()}


local function newTile(startCoordinate, static, friction, color)
    return {
        startCoordinate=startCoordinate,
        static=static,
        friction=friction,
        color=color
    }
end

function Map.generate(sizeX, sizeY)
    Map.size.x = sizeX
    Map.size.index.x = sizeX / 16
    Map.size.y = sizeY
    Map.size.index.y = sizeY / 16

    for x = 1, sizeX, 1 do 
        local yTable = {}

        for y = 1, sizeY, 1 do
            local tileX = (x-1) + (x - 1) * 16
            local tileY = (y - 1) + (y - 1) * 16

            if x == 1 or y == 1 then
                table.insert(yTable, newTile({x=tileX,y=tileY},true, 0.1, {r=0.5,g=0.5,b=0.5}))
            else
                table.insert(yTable, newTile({x=tileX,y=tileY},false, 0.67, {r=0,g=0.5,b=0}))
            end
        end

        table.insert(Map.tiles, yTable)
    end
end

function Map.getIndicesFromPosition(position)
    local xIndex = math.min(math.floor(position.x / 16) + 1, 1)
    local yIndex = math.min(math.floor(position.y / 16) + 1, 1)
    return {x=xIndex,y=yIndex}
end

function Map.getTileAtIndices(indices)
    return Map.tiles[indices.x][indices.y]
end

function Map.getTileAtPosition(position)
    local xIndex = math.min(math.floor(position.x / 16) + 1, 1)
    local yIndex = math.min(math.floor(position.y / 16) + 1, 1)
    return Map.tiles[xIndex][yIndex]
end

function Map.updateTileAtIndices(indices, newTile)
    Map.tiles[indices.x][indices.y] = newTile
end

function Map.draw()
    local width = #Map.tiles

    for x=0, width - 1, 1 do
        local xIndex = x + 1
        local height = #Map.tiles[xIndex]
        for y=0, height - 1, 1 do
            local yIndex = y + 1
            local tileValue = Map.tiles[xIndex][yIndex]
            
            love.graphics.setColor(tileValue.color.r, tileValue.color.g, tileValue.color.b)
            love.graphics.rectangle('fill', tileValue.startCoordinate.x, tileValue.startCoordinate.y, 16, 16)
        end
    end
end

return Map