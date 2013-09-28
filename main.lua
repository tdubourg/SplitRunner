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

system.activate("multitouch")


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

local player = Player.new("player", 50, 300, 1)
local player2 = Player.new("player2", 50, 50, -1)

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

local function onCollision( event )
    local type1 = event.object1.objectType
    local type2 = event.object2.objectType
    --print("collision between " .. type1 .. " and " .. type2)
    if type1 == "player" or type2 == "obstacle" then
        --print("collision")
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
        local wheel = display.newRect(0, 0, 20, 20)
        wheel.x = xPosition
        -- random initial rotation
        wheel.rotation = math.random(0, 180)
        wheel.y = y
        print(wheel.height)
        wheel:setFillColor(0, 0, 255)
        table.insert(wheels, wheel)
    end
end

local function onEnterFrameWheels()
    for i, wheel in ipairs(wheels) do
        wheel.rotation = wheel.rotation + 3
    end
end

-- top wheels
createWheels(0  )
-- bottom wheels
createWheels(display.viewableContentHeight)

Runtime:addEventListener( "enterFrame", onEnterFrameWheels)


--[[
CBE=require("CBEffects.Library")
local heavy_rain=CBE.VentGroup{
    {
        preset="sparks",
        title="explosion",
        build=function()
            local shape=display.newImageRect("Textures/particle_with_trail.png", 5, 30)
            shape:setReferencePoint(display.CenterLeftReferencePoint)
            return shape
        end,
        onCreation=function(particle)
            particle:applyForce((math.random(-10, 10)/25), (math.random(-10, 10)/25))
        end,
        color={{255, 255, 0}},
        positionType="atPoint",
        perEmit=6,
        onDeath=function()end,
        rotateTowardVel=true,
        physics={
            sizeY=-0.02,
            velocity=2,
            gravityY=0.05,
            iterateAngle=true,
            autoAngle=false,
            angles={
                0, 60, 120, 180, 240, 300
            }
        }
    },
}
heavy_rain:start("explosion")
]]