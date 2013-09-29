local physics = require( "physics" )
--physics.setDrawMode("hybrid") -- debug purpose only
Player = {}

Player.__index = Player

PLAYER_HORIZONTAL_VELOCITY = 0
JUMP_VELOCITY = 150
-- The following constants define the widht and height of the player in percentage of the screen so that the player
-- takes the same amount of space on a small and on a big screen
PLAYER_WIDTH_IN_PERCENTAGE = 10
PLAYER_HEIGHT_IN_PERCENTAGE = 10

PLAYER_SPRITE_RAW_WIDTH = 200
PLAYER_SPRITE_RAW_HEIGHT = 200

local PLAYER_SPRITE_SEQUENCE_DATA = {
    { name="normalRun", start=1, count=8, time=300},
    { name="jump", start=9, count=4, time=100}
}

function Player.new(objectType, x, y, gravityScale, spriteWidth, spriteHeight)
    local self = {}
    self.doubleJumpCount = 0
    setmetatable(self, Player)
    self.coronaObject = nil
    local imageSheet = graphics.newImageSheet("images/player_spritesheet.png", {width = PLAYER_SPRITE_RAW_WIDTH,
        height = PLAYER_SPRITE_RAW_HEIGHT, numFrames = 12})

    self.coronaObject = display.newSprite(imageSheet, PLAYER_SPRITE_SEQUENCE_DATA)
    self.coronaObject.y = y
    self.coronaObject:setFillColor(0, 255, 0)
    self.objectType = objectType
    self.coronaObject.objectType = objectType
    self.coronaObject.playerObject = self
    self.coronaObject.width, self.coronaObject.height = spriteWidth, spriteHeight
    self.coronaObject.xScale, self.coronaObject.yScale = spriteWidth / PLAYER_SPRITE_RAW_WIDTH,
    spriteHeight / PLAYER_SPRITE_RAW_HEIGHT
    addBodyWithCutCornersRectangle(self.coronaObject, 30)
    self.coronaObject:play()

    self.coronaObject.gravityScale = gravityScale
    return self
end

function Player:jump()
    if (self.doubleJumpCount > 1) then
        return
    end
    self.coronaObject:setLinearVelocity(PLAYER_HORIZONTAL_VELOCITY, self.coronaObject.gravityScale * (-1) * JUMP_VELOCITY)
    self.coronaObject:setSequence("jump")
    self.doubleJumpCount = self.doubleJumpCount + 1
end

function Player:resetDoubleJumpCounter()
    self.doubleJumpCount = 0
end

function Player:draw(event)

end

function Player:update(seconds)
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

    local collisionFilter = { categoryBits = 2, maskBits = 5 } -- collides with player only

    physics.addBody(displayObject, "dynamic", { shape = {
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
    }, filter=collisionFilter})
    displayObject.isFixedRotation = true
end

function Player.activateBonus(bonus)
    print("TODO Player.activateBonus")
end