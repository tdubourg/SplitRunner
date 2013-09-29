local physics = require( "physics" )
physics.setDrawMode("hybrid") -- debug purpose only
require("anim")
Player = {}

Player.__index = Player

PLAYER_HORIZONTAL_VELOCITY = 0
JUMP_VELOCITY = 150
-- The following constants define the widht and height of the player in percentage of the screen so that the player
-- takes the same amount of space on a small and on a big screen
PLAYER_WIDTH_IN_PERCENTAGE = 10
PLAYER_HEIGHT_IN_PERCENTAGE = 10

local spriteSequenceData = {
    { name="normalRun", start=1, count=8, time=800 },
    { name="fastRun", frames={ 1,2,4,5,6,7 }, time=250, loopCount=0 }
}

function Player.new(objectType, x, y, gravityScale, spriteWidth, spriteHeight)
    local self = {}
    setmetatable(self, Player)
    self.coronaObject = nil
    local collisionFilter = { categoryBits = 2, maskBits = 5 } -- collides with player only
    local body = { filter=collisionFilter }
    self.coronaObject = display.newRect(x, y, 20, 20)
    self.coronaObject.y = y
    self.coronaObject:setFillColor(0, 255, 0)
    self.coronaObject.objectType = objectType
    physics.addBody ( self.coronaObject , "dynamic", body )
--    display.newSprite( mySheet, sequenceData )
    self.anim = Anim.new('boy', spriteWidth, spriteHeight)
    --self.coronaObject .isFixedRotation = true

    --physics.addBody( rect, "dynamic" )

    self.coronaObject.gravityScale = gravityScale
    return self
end

function Player:jump()
    self.coronaObject:setLinearVelocity(PLAYER_HORIZONTAL_VELOCITY, self.coronaObject.gravityScale * (-1) * JUMP_VELOCITY)

end

function Player:draw(event)

end

function Player:update(seconds)
    self.anim:update(seconds)
    self.anim.currentImg.x = self.coronaObject.x
    self.anim.currentImg.y = self.coronaObject.y
    self.anim.currentImg.isVisible = true
end


-- @function addBodyWithCutCornersRectangle
-- will add a DYNAMIC body to the physics engine after cutting the corners of the displayObject rectangle
-- it will cut the corners at percentageOfCut percentage of the corner (percentageOfCut = 10 and displayObject has a
--  widht of 200 would mean for instance that we will transform the 200 edge into a 200-2*200*10/100 edge (cutting
--   corners on both sides at 10 percent...)
-- with a density of 1 and a friction of 1
function addBodyWithCutCornersRectangle(displayObject, percentageOfCut)
    -- If the user is stupid enough to give 0, avoid tue division by zero by falling back to a percentage of 10
    if percentageOfCut == 0 or percentageOfCut == nil then
        percentageOfCut = 10
    end
    h, w = displayObject.height, displayObject.width

    physics.addBody(displayObject, "dynamic", { fixedRotation = true, friction = 1, density=1.0, shape = {
        -- shape is counter-clockwisedly descripted
        -- bottom left corner --
        -w/2, -h/2 + h*percentageOfCut/100,
        -w/2 + w*percentageOfCut/100, -h/2,
        -- bottom right corner --
        w/2 - w*percentageOfCut/100, -h/2,
        w/2, -h/2 + h*percentageOfCut/100,
        -- top right corner --
        w/2, h/2 - h*percentageOfCut/100,
        w/2 - w*percentageOfCut/100, h/2,
        -- top left corner --
        -w/2 + w*percentageOfCut/100, h/2,
        -w/2, h/2 - h*percentageOfCut/100,
    }})
    displayObject.isFixedRotation = true
end