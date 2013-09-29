local BonusManagerTimer

BonusManager = {}

BonusManager.__index = BonusManager

bonuses = {}

--BONUS_RANDOM = 0.003
BONUS_RANDOM = 0.01

function BonusManager.new(args) -- constructor
    local self = {}
    setmetatable(self, BonusManager)
    bonuses = {}
    return self
end

function BonusManager:activateBonus(bonus, x, y)
    if (bonus.effectDone == true) then
       return
    end
    bonus.effectDone = true
    local effect = getSparkEffect(x, y)
    effect:start("explosion")
    local stopEffectClosure = function()
        effect:stop("explosion")
        effect:destroy()
        effect=nil
        return
    end
    timer.performWithDelay(400, stopEffectClosure)
    bonusManager:removeBonus(bonus)
end

function BonusManager:removeBonus(bonus)
    bonus:removeSelf()
end

function setBonusImages(object)

	if (object.hiddenType == 1) then
        object.image = "fall.png"   
    elseif (object.hiddenType == 2) then
        object.image = "blind.png"   
    end
end

local function generateBonus(y)
    local BonusManagerHeight = 10
    local object = display.newImage("assets/surprise.png");
    object.width = 20;
    object.height = 20;
    object.y = y
    object.x = display.viewableContentWidth + 20
    object.hiddenType = math.random(1,2)
    if (object.hiddenType == 1) then
        object:setFillColor ( 255, 0, 0)   
    elseif (object.hiddenType == 2) then
        object:setFillColor ( 0, 0, 255  )
    end
    --define images to show per bonus
    setBonusImages(object)
    --object:setFillColor ( 255, 0, 0 , 0 )
    object.objectType = "bonus"
    local collisionFilter = { categoryBits = 5, maskBits = 2 } -- collides with player only
    local body = { friction=0.5, bounce=0.2 , filter=collisionFilter }
    physics.addBody( object, "static", body )
    table.insert(bonuses, object)
    level1SceneBGLayer:insert(object)
    return object
end

local function onEnterFrameBonusManager(event)
    -- existing ones
    local velocity = 2
    for i, bonus in ipairs(bonuses) do
        if (bonus.x == nil) then
            --
        else
            if (bonus.x < 10) then
                bonusManager:removeBonus(bonus)
                break
            end
            bonus.x = bonus.x - velocity
        end
    end
    -- new ones
    local random = math.random()
    local yPosition = 0
    local top = math.random() < 0.5
    if (top) then
        yPosition = display.viewableContentHeight / 4 + math.random(0, 10)
    else
        yPosition = display.viewableContentHeight / 4 * 3 - math.random(0, 10)
    end
    if random < BONUS_RANDOM then
        local bonus = generateBonus(yPosition)
        if (top) then
            bonus.yScale = -1
            bonus.xScale = -1
        end
    end
end

function BonusManager:cancelTimersAndListeners()
--    for i, bonus in ipairs(bonuses) do
--        if bonus ~= nil then
--            self:removeBonus(bonus)
--        end
--    end

    Runtime:removeEventListener("enterFrame", onEnterFrameBonusManager)
end

function BonusManager:initTimersAndListeners()
    Runtime:addEventListener( "enterFrame", onEnterFrameBonusManager)
end
