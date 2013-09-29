local physics = require( "physics" )

Player = {}

Player.__index = Player
PLAYER_HORIZONTAL_VELOCITY = 0
JUMP_VELOCITY = 150
PLAYER_HORIZONTAL_VELOCITY = 0
function Player.new(objectType, x, y, gravityScale)
    local self = {}
    self.doubleJumpCount = 0
    setmetatable(self, Player)
    self.coronaObject = nil
    local collisionFilter = { categoryBits = 2, maskBits = 5 } -- collides with player only
    local body = { filter=collisionFilter }
    self.coronaObject = display.newRect(  x, y, 20, 20)
    self.coronaObject .y = y
    self.coronaObject.playerObject = self
    self.coronaObject :setFillColor(0, 255, 0)
    self.coronaObject.objectType = objectType
    self.objectType = objectType
    physics.addBody ( self.coronaObject , "dynamic", body )
--    self.anim = Anim.new('boy')
    --self.coronaObject .isFixedRotation = true

    --physics.addBody( rect, "dynamic" )
    self.coronaObject.gravityScale = gravityScale
    return self
end

function Player:jump()
    if (self.doubleJumpCount > 1) then
        return
    end
    self.coronaObject:setLinearVelocity(PLAYER_HORIZONTAL_VELOCITY, self.coronaObject.gravityScale * (-1) * JUMP_VELOCITY)
    self.doubleJumpCount = self.doubleJumpCount + 1
end

function Player:resetDoubleJumpCounter()
    print ("reset")
    self.doubleJumpCount = 0
end