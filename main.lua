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

system.activate("multitouch")

setBackgrounds()

-- Set the background color to white  
local background = display.newRect( 0, 0, display.viewableContentWidth, display.viewableContentHeight)
background:setFillColor( 255, 255, 255,0 )  local beginX 
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

local player = Player.new()
player = player:create("player", 50, 300, 1)
local player2 = Player.new()
player2 = player2:create("player2", 50, 50, -1)

local function onTouch( event )
    local o
    local velocity
    local jumpImpulsion = 150
    local middleHeight = display.viewableContentHeight / 2
    if event.y > middleHeight then
        o = player
        velocity = jumpImpulsion * -1
    else
        o = player2
        velocity = jumpImpulsion
    end
    if "began" == event.phase then
        o.isFocus = true
        o:setLinearVelocity(0, velocity)
    elseif o.isFocus then
        if "moved" == event.phase then
            -- nowt
        elseif "ended" == phase or "cancelled" == phase then
            o.isFocus = false
        end
    end

    -- Return true if the touch event has been handled.
    return true
end

local function onCollision( event )
    local type1 = event.object1.objectType
    local type2 = event.object2.objectType
    --print("collision between " .. type1 .. " and " .. type2)
end
local isPlayer1local isPlayer2function checkSwipeDirection()	            isPlayer1 = false				isPlayer2 = false				local middleHeight = display.viewableContentHeight / 2				if beginY > middleHeight then
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
                        if totalSwipeDistanceLeft > minSwipeDistance then                        	if isPlayer1 == true then                        		native.showAlert("test","Swiped Left Player1")                        	else                        		native.showAlert("test","Swiped Left Player2")                        	end
                        end
                    else 
                        totalSwipeDistanceRight = endX - beginX
                        if totalSwipeDistanceRight > minSwipeDistance then
                            if isPlayer1 == true then                        		native.showAlert("test","Swiped Right Player1")                        	else                        		native.showAlert("test","Swiped Right Player2")                        	end
                        end
                    end
                else 
                 if beginY > endY then
                        totalSwipeDistanceUp = beginY - endY                        print(totalSwipeDistanceUp)                        print(isPlayer1)
                        if totalSwipeDistanceUp > minSwipeDistance then                        	if isPlayer1 == true then
                                native.showAlert("test","Player1 Attack")                        	end
                        end
                     else 
                        totalSwipeDistanceDown = endY - beginY                        print(totalSwipeDistanceDown)
                        if totalSwipeDistanceDown > minSwipeDistance then
                                if isPlayer2 == true then                                	native.showAlert("test","Player2 Attack")                                end
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
topGround = topGround:create(0)

local ground = Ground.new()
ground = ground:create(display.viewableContentHeight)


local middleGround = Ground.new()
middleGround = middleGround:create(display.viewableContentHeight / 2)
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