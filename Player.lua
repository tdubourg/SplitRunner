local physics = require( "physics" )
require("utils")
--physics.setDrawMode("hybrid") -- debug purpose only
Player = {}

Player.__index = Player

PLAYER_HORIZONTAL_VELOCITY = 0
JUMP_VELOCITY = 200
-- The following constants define the widht and height of the player in percentage of the screen so that the player
-- takes the same amount of space on a small and on a big screen
PLAYER_WIDTH_IN_PERCENTAGE = 10
PLAYER_HEIGHT_IN_PERCENTAGE = 10

PLAYER_SPRITE_RAW_WIDTH = 200
PLAYER_SPRITE_RAW_HEIGHT = 200

PLAYER_JUMP_STATE = 42
PLAYER_RUN_STATE = 43
POSITIVE_X_VELOCITY_FRICTION_COUNTER_BALANCE = 0.08

local PLAYER_SPRITE_SEQUENCE_DATA = {
    { name="normalRun", start=1, count=8, time=400},
    { name="jump", start=9, count=4, time=400}
}

function Player.new(objectType, name, x, y, gravityScale, spriteWidth, spriteHeight)
    local self = {}
    setmetatable(self, Player)
    self.currentState = PLAYER_RUN_STATE
    self.doubleJumpCount = 0
    self.name = name
    self.coronaObject = nil
    local imageSheet = graphics.newImageSheet("images/player_spritesheet.png", {width = PLAYER_SPRITE_RAW_WIDTH,
        height = PLAYER_SPRITE_RAW_HEIGHT, numFrames = 12, sheetContentWidth=2400, sheetContentHeight=200})

    self.coronaObject = display.newSprite(imageSheet, PLAYER_SPRITE_SEQUENCE_DATA)
    self.coronaObject.x = x
    self.coronaObject.y = y
    self.objectType = objectType
    self.coronaObject.objectType = objectType
    self.coronaObject.playerObject = self
    self.coronaObject.width, self.coronaObject.height = spriteWidth, spriteHeight
    self.coronaObject.xScale, self.coronaObject.yScale = spriteWidth / PLAYER_SPRITE_RAW_WIDTH,
    signof(gravityScale) * spriteHeight / PLAYER_SPRITE_RAW_HEIGHT
    addBodyWithCutCornersRectangle(self.coronaObject, 30)
    self.bonusImage = nil
    self.coronaObject:play()
	if (gravityScale == 1) then
		self.isPlayer1 = true
	else
		self.isPlayer2 = true
	end
    self.coronaObject.gravityScale = gravityScale
    return self
end

function Player:jump()
    if (self.doubleJumpCount > 1) then
        return
    end

    local vx, vy = self.coronaObject:getLinearVelocity()
    -- If falling from surface where we landed previously, has the right to have a small jump, but not a full one
    if self.currentState ~= PLAYER_JUMP_STATE and signof(self.coronaObject.gravityScale) * vy > 0 then
        reduction_coeff = 1/3
    else
        -- Full jump the first time, 2/3 of a full jump the second time
        reduction_coeff = (3 - self.doubleJumpCount) / 3
    end

    self.currentState = PLAYER_JUMP_STATE
    self.coronaObject:setLinearVelocity(
        PLAYER_HORIZONTAL_VELOCITY,
        self.coronaObject.gravityScale * (-1) * JUMP_VELOCITY * reduction_coeff
    )
    self.coronaObject:setSequence("jump")
    self.coronaObject:play()
    self.doubleJumpCount = self.doubleJumpCount + 1
end

-- Did we just land on some sort of object?
function Player:landedOn(collider)
    if collider.objectType == "obstacle" then
        self.coronaObject:setLinearVelocity(POSITIVE_X_VELOCITY_FRICTION_COUNTER_BALANCE, 0)
    else
        self.coronaObject:setLinearVelocity(0, 0)
    end

    self.currentState = PLAYER_RUN_STATE
    self.coronaObject:setSequence("normalRun")
    self.coronaObject:setLinearVelocity(0, 0)
    self.coronaObject:play()
    self:resetDoubleJumpCounter()
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
    }, filter=collisionFilter, friction = 0.0})
    displayObject.isFixedRotation = true
end

function Player:assignBonus(bonus)
    self.currentBonus = bonus

    if (self.bonusImage ~= nil)then
     	self.bonusImage:removeSelf()
    end
    self.bonusImage = display.newImage("images/"..bonus.image)
    local variation = display.viewableContentHeight/7
    if (self.isPlayer1) then
		self.bonusImage.x = 45
		self.bonusImage.y = display.viewableContentHeight/2 + variation
    else
    	self.bonusImage.x = display.viewableContentWidth - 45
    	self.bonusImage.y = display.viewableContentHeight/2 - variation
    	self.bonusImage.yScale = -1
    end
    	self.bonusImage.width = display.viewableContentHeight/7
		self.bonusImage.height = self.bonusImage.width
        level1Scene:insert(self.bonusImage)
end

function Player:activateBonus(gravityScale)
    local bonus = self.currentBonus
    if (bonus == nil) then
       return
    end
    print("removeImage"..self.bonusImage.x)
    self.bonusImage:removeSelf()
    self.bonusImage = nil
    if (bonus.hiddenType == 1) then
        for i, obstacle in ipairs(obstacles) do
            obstacle.gravityScale = gravityScale * 8
        end
        local restoreObstacleGravityClosure = function()
            for i, obstacle in ipairs(obstacles) do
                obstacle.gravityScale = gravityScale
            end
        end
        timer.performWithDelay(500, restoreObstacleGravityClosure)
    elseif (bonus.hiddenType == 2)then
        local effect = getSmokeWallEffect(gravityScale)
        effect:start("smoke")
        local stopEffectClosure = function()
            effect:stop("smoke")
            effect:destroy()
            effect=nil
            return
        end
        timer.performWithDelay(5000, stopEffectClosure)
    elseif (bonus.hiddenType == 3) then
    	if (self.isPlayer1 == true) then
    		transition.to (self.coronaObject, {3000, x = self.coronaObject.x+80})
    	else
    		transition.to (self.coronaObject, {3000, x = self.coronaObject.x+80})
    	end
    end
    self.currentBonus = nil
end