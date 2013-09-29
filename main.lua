-- Project: SplitRun
-- Description:
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
---- cpmgen main.lua


local sprite = require("sprite")

local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )

require("Player")
require("Ground")
require("Obstacle")

require("Effects")

system.activate("multitouch")

MAIN_UPDATE_DELAY = 1/30 -- 30 updates per seconds

--load BGs images and set their positions
local background = display.newImage("images/background.png")
background.x = 240
background.y = 160
local midBackground = display.newImage("images/bgfar1.png")
midBackground.x = 480
midBackground.y = 160

local function updateBackgrounds()
	--move backgrounds
	background.x = background.x - (.25)
	midBackground.x = midBackground.x - 3
end

local function update(event)
	--updateBackgrounds()
end

-- call Update every 1 ms for an unlimited amount of time thanks to -1
timer.performWithDelay(1, update, -1)









-- Set the background color to white  
local background = display.newRect( 0, 0, display.viewableContentWidth, display.viewableContentHeight)
background:setFillColor( 255, 255, 255, 0 )

local pW, pH = display.contentWidth* PLAYER_WIDTH_IN_PERCENTAGE / 100, display.contentHeight * PLAYER_HEIGHT_IN_PERCENTAGE / 100
local player = Player.new("player", 50, 300, 1, pW, pH)
local player2 = Player.new("player2", 50, 50, -1, pW, pH)

local function onTouch( event )
    local o
    local velocity
    local middleHeight = display.viewableContentHeight / 2
    if event.y > middleHeight then
        p = player
    else
        p = player2
    end

    -- condition equivalent to a check of "onKeyDown", in order not to repeat the action when the touch event lasts
    if "began" == event.phase then
        p:jump()
    end

    -- Return true if the touch event has been handled.
    return true
end

local function stopSmokeEffect(effect)
    --effect:stop("smoke")
    effect:destroy()
    effect=nil
end

local function onCollision( event )
    local type1 = event.object1.objectType
    local type2 = event.object2.objectType
    --print("collision between " .. type1 .. " and " .. type2)
    if (type1 == "obstacle" and type2 == "ground") or (type2 == "obstacle" and type1 == "ground") then
        -- objet auquel on va attacher la fumée
        print(event.force)
        local toAttach
        if (type1 == "obstacle") then
            toAttach = event.object1
         else
            toAttach = event.object2
        end
        local smokeXPosition = toAttach.x - 20
        local smokeYPosition
        if (toAttach.y < 100) then
            smokeYPosition = 15
        else
            smokeYPosition = display.viewableContentHeight - 20
        end
        local smokeEffect = getSmokeEffect(smokeXPosition, smokeYPosition)
        smokeEffect:start("smoke")
        local stopEffectClosure = function()
            return smokeEffect:stop("smoke")
        end
        timer.performWithDelay(200, stopEffectClosure)
    else
    end
end


-- GROUNDS
local topGround = Ground.new()
topGround = topGround:create(10)

local ground = Ground.new()
ground = ground:create(display.viewableContentHeight - 10)

--[[
local middleGround = Ground.new()
middleGround = middleGround:create(display.viewableContentHeight / 2)
middleGround:setFillColor ( 0, 0, 0  )
]]
local middleGround = display.newRect(0 ,0, display.viewableContentWidth, 5);
middleGround.y = display.viewableContentHeight / 2
middleGround:setFillColor ( 0, 0, 0  )
Runtime:addEventListener ( "collision", onCollision )

-- Only the background receives touches. 
background:addEventListener( "touch", onTouch)



-- OBSTACLES
-- random obstacles
obstacles = {}
local function generateObstacle()
    local obstacle = Obstacle.new()
    obstacle = obstacle:create()
    -- equivalent de push
    table.insert(obstacles, obstacle)
end

local function obstacleTimer()
    local random = math.random()
    if random > 0.7 then
       generateObstacle()
    end
    timer.performWithDelay(500, obstacleTimer)
end
-- bootstrap
timer.performWithDelay(500, obstacleTimer)

-- animation des obstacles existants
local function onEnterFrameObstacles(event)
    local velocity = 2
    for i, obstacle in ipairs(obstacles) do
        obstacle.x = obstacle.x - velocity
    end
    player:draw(event)
    player2:draw(event)
end

Runtime:addEventListener( "enterFrame", onEnterFrameObstacles)









-- TAPIS ROULANT

local wheels = {}

local function createWheels(y)
    local width = display.viewableContentWidth;
    local nbWheels = 6
    local ratio = width / nbWheels
    for i = 1,6 do
        local xPosition = (ratio * i) - (ratio / 2)
        local wheel = display.newImage("assets/roue.png")
        wheel.x = xPosition
        wheel.width = 30
        wheel.height = 30
        -- random initial rotation
        wheel.rotation = math.random(0, 180)
        wheel.y = y
        table.insert(wheels, wheel)
    end
end

local function onEnterFrameWheels()
    for i, wheel in ipairs(wheels) do
        wheel.rotation = wheel.rotation - 3
    end
end

local function onEnterFrame(event)
    player:draw(event)
    player2:draw(event)
end

updateLastTime = system.getTimer()
local function mainUpdate()
    local time = system.getTimer()
    local seconds = time - updateLastTime
    updateLastTime = time
    player:update(seconds)
    player2:update(seconds)
end

timer.performWithDelay( MAIN_UPDATE_DELAY, mainUpdate, 0 )

-- top wheels
createWheels(0)
-- bottom wheels
createWheels(display.viewableContentHeight)

Runtime:addEventListener( "enterFrame", onEnterFrameWheels)
Runtime:addEventListener( "enterFrame", onEnterFrame)
