local physics = require( "physics" )

Player = {}

Player.__index = Playerfunction Player.new(args) -- constructor
    local self = {}
    setmetatable(self, Player)
    return self
end

function Player:create( objectType, x, y, gravityScale)
    local object
    local collisionFilter = { categoryBits = 2, maskBits = 5 } -- collides with player only
    local body = { filter=collisionFilter }
    object = display.newRect(  x, y, 20, 20)
    object.y = y
    object:setFillColor(0, 255, 0)
    object.objectType = objectType
    physics.addBody ( object, "dynamic", body )
    --object.isFixedRotation = true

    --physics.addBody( rect, "dynamic" )

    object.gravityScale = gravityScale
    return object
end