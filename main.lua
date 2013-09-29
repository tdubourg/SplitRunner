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
require("background")

require("Effects")

system.activate("multitouch")

setBackgrounds()










-- Set the background color to white  
local background = display.newRect( 0, 0, display.viewableContentWidth, display.viewableContentHeight)
background:setFillColor( 255, 255, 255,0 )

local beginX 
local beginY  
local endX  
local endY 
 
local xDistance  
local yDistance
 
local bDoingTouch
local minSwipeDistance = 80
local totalSwipeDistanceLeft
local totalSwipeDistanceRight
local totalSwipeDistanceUp
local totalSwipeDistanceDown

local player = Player.new("player", 50, 300, 1)
local player2 = Player.new("player", 50, 50, -1)


-- BONUS 1
local function activateBonus1(gravityScale)
    for i, obstacle in ipairs(obstacles) do
        obstacle.gravityScale = gravityScale * 8
    end
    local restoreObstacleGravityClosure = function()
        for i, obstacle in ipairs(obstacles) do
            obstacle.gravityScale = gravityScale
        end
        return
    end
    timer.performWithDelay(500, restoreObstacleGravityClosure)
end



local function onTouch( event )
    local o
    local velocity
    --activateBonus1(-1)
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

local function onCollision( event )
    local type1 = event.object1.objectType
    local type2 = event.object2.objectType
    --print("collision between " .. type1 .. " and " .. type2)
    if (type1 == "obstacle" and type2 == "ground") or (type2 == "obstacle" and type1 == "ground") then
        -- objet auquel on va attacher la fumée
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
            smokeEffect:stop("smoke")
            smokeEffect:destroy()
            smokeEffect=nil
            return
        end
        timer.performWithDelay(200, stopEffectClosure)
    elseif (type1 == "player" and type2 == "ground") or (type2 == "player" and type1 == "ground") then
        local player
        if (type1 == "player") then
            player = event.object1.playerObject
        else
            player = event.object2.playerObject
        end
        player:resetDoubleJumpCounter()
    end
end

function checkSwipeDirection()
    local isPlayer1 = false
    local isPlayer2 = false
    local middleHeight = display.viewableContentHeight / 2
    if (beginY == nil) then
        return
    end
    if beginY > middleHeight then
        isPlayer1 = true
    else
        isPlayer2 = true
    end
    if bDoingTouch == true then
        xDistance =  math.abs(endX - beginX) -- math.abs will return the absolute, or non-negative value, of a given value.
        yDistance =  math.abs(endY - beginY)
        if xDistance > yDistance then
                if beginX > endX then
                    totalSwipeDistanceLeft = beginX - endX
                if totalSwipeDistanceLeft > minSwipeDistance then
                if isPlayer1 == true then
                    native.showAlert("test","Swiped Left Player1")
                else
                    native.showAlert("test","Swiped Left Player2")
                    end
                end
            else
                totalSwipeDistanceRight = endX - beginX
                if totalSwipeDistanceRight > minSwipeDistance then
                    if isPlayer1 == true then
                        native.showAlert("test","Swiped Right Player1")
                    else
                        native.showAlert("test","Swiped Right Player2")
                    end
                end
            end
        else
         if beginY > endY then
                totalSwipeDistanceUp = beginY - endY
                if totalSwipeDistanceUp > minSwipeDistance then
                    if isPlayer1 == true then
                        native.showAlert("test","Player1 Attack")
                    end
                end
             else
                totalSwipeDistanceDown = endY - beginY
                if totalSwipeDistanceDown > minSwipeDistance then
                   if isPlayer2 == true then
                        native.showAlert("test","Player2 Attack")
                   end
                end
             end
        end
    end
 end
 
 function swipe(event)
    if event.phase == "began" then
        bDoingTouch = true
        beginX = event.x
        beginY = event.y
        end
    if event.phase == "ended"  then
        endX = event.x
        endY = event.y
        checkSwipeDirection();
        bDoingTouch = false
    end
end
 
background:addEventListener("touch", swipe)

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
end

Runtime:addEventListener( "enterFrame", onEnterFrameObstacles)









-- TAPIS ROULANT

local wheels = {}

local function createWheels(y)
    local width = display.viewableContentWidth;
    local nbWheels = 6
    local ratio = width / nbWheels
    local tapis = display.newImage("assets/tapis.png")
    tapis.width = display.viewableContentWidth;
    tapis.height = 40
    tapis.y = y
    tapis.x = tapis.width / 2
    local offset = 5
    if (y < 100) then
       tapis.y = tapis.y - offset
    else
        tapis.y = tapis.y + offset
    end
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
        wheel.rotation = wheel.rotation - 4
    end
end

-- top wheels
createWheels(0)
-- bottom wheels
createWheels(display.viewableContentHeight)

Runtime:addEventListener( "enterFrame", onEnterFrameWheels)

