<<<<<<< HEAD
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
=======
local physics = require( "physics" )

Player = {}

Player.__index = Player

PLAYER_HORIZONTAL_VELOCITY = 0
JUMP_VELOCITY = 150

function Player.new(objectType, x, y, gravityScale)
    local self = {}
    setmetatable(self, Player)
    self.coronaObject = nil
    local collisionFilter = { categoryBits = 2, maskBits = 5 } -- collides with player only
    local body = { filter=collisionFilter }
    self.coronaObject = display.newRect(  x, y, 20, 20)
    self.coronaObject .y = y
    self.coronaObject :setFillColor(0, 255, 0)
    self.coronaObject .objectType = objectType
    physics.addBody ( self.coronaObject , "dynamic", body )
--    self.anim = Anim.new('boy')
    --self.coronaObject .isFixedRotation = true

    --physics.addBody( rect, "dynamic" )

    self.coronaObject.gravityScale = gravityScale
    return self
end

function Player:jump()
    self.coronaObject:setLinearVelocity(PLAYER_HORIZONTAL_VELOCITY, self.coronaObject.gravityScale * (-1) * JUMP_VELOCITY)
>>>>>>> baf5aaa3129bbe90f3ba1eca7d6a132d58ae56b7
end