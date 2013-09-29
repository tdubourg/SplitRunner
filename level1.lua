
local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

local sprite = require("sprite")
require("utils")
local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )

require("Player")
require("Ground")
require("Obstacle")
require("background")

require("Effects")

require("BonusManager")
bonusManager = nil

system.activate("multitouch")

MAIN_UPDATE_DELAY = 1/30 -- 30 updates per seconds

-- Set the background color to white
local background = display.newRect( 0, 0, display.viewableContentWidth, display.viewableContentHeight)
background:setFillColor( 255, 255, 255,0 )

local xDistance
local yDistance
 
local bDoingTouch
local minSwipeDistance = 80
local totalSwipeDistanceLeft
local totalSwipeDistanceRight
local totalSwipeDistanceUp
local totalSwipeDistanceDown
local gameIsOver = false
local MainUpdateTimer
local ObstacleTimer
local topGround
local ground
local middleGround
level1Scene = nil

PLAYER_SPAWN_IN_PERCENTAGE_OF_WIDTH = 70
PLAYER_TOP_SPAWNY = 50
PLAYER_BOTTOM_SPAWNY = 300

local pW, pH = display.contentWidth* PLAYER_WIDTH_IN_PERCENTAGE / 100, display.contentHeight * PLAYER_HEIGHT_IN_PERCENTAGE / 100
local playerSpawn = PLAYER_SPAWN_IN_PERCENTAGE_OF_WIDTH * display.contentWidth / 100
local playerB
local playerT

local function onTouch( event )
    local o
    local velocity
    local middleHeight = display.viewableContentHeight / 2
    if event.y > middleHeight then
        p = playerB
    else
        p = playerT
    end

    -- condition equivalent to a check of "onKeyDown", in order not to repeat the action when the touch event lasts
    if "began" == event.phase then
        p:jump()
    end

    -- Return true if the touch event has been handled.
    return true
end

local function onCollision( event )
    physics.setReportCollisionsInContentCoordinates( true )
    local type1 = event.object1.objectType
    local type2 = event.object2.objectType
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
    elseif (type1 == "player" and type2 == "bonus") or (type2 == "player" and type1 == "bonus") then
        local bonus
        local player
        local coronaObject
        event.contact.isEnabled = false
        if (type1 == "bonus") then bonus = event.object1 else bonus = event.object2 end
        if (type1 == "player") then player = event.object1.playerObject else player = event.object2.playerObject end
        if (type1 == "player") then coronaObject = event.object1 else coronaObject = event.object2 end
        bonusManager:activateBonus(bonus, bonus.x - 10, bonus.y)
        player:assignBonus(bonus)
    else
        player, collider = nil, nil
        -- Is one of the colliders a player and the other one either an obstacle or the ground?
        if (type1 == "player" and (type2 == "ground" or type2 == "obstacle")) then
            player = event.object1.playerObject
            collider = event.object2
        elseif (type2 == "player" and (type1 == "ground" or type1 == "obstacle")) then
            player = event.object2.playerObject
            collider = event.object1
        end

        -- If we indeed had one of the 2 previous condition fulfilled:
        if player ~= nil then
            local vx, vy = player.coronaObject:getLinearVelocity()
            -- Then, is this collision a "landing" on the other collider?
            if (event.x >= player.coronaObject.x - player.coronaObject.width/2)
                and (event.x <= (player.coronaObject.x + player.coronaObject.contentWidth/2))
                    and ((signof(player.coronaObject.gravityScale) * vy) > 0) then
                player:landedOn(collider)
            end
        end
    end
end

function checkSwipeDirection(event)
    local isPlayer1 = false
    local isPlayer2 = false
    local middleHeight = display.viewableContentHeight / 2
   -- if (beginY == nil) then
      --  return
    --end
    if event.yStart > middleHeight then
        isPlayer1 = true
    else
        isPlayer2 = true
    end
    if bDoingTouch == true then
        xDistance =  math.abs(event.x - event.xStart) -- math.abs will return the absolute, or non-negative value, of a given value.
        yDistance =  math.abs(event.y - event.yStart)
        if xDistance > yDistance then
        	if event.xStart > event.x then
                    totalSwipeDistanceLeft = event.xStart - event.x
                if totalSwipeDistanceLeft > minSwipeDistance then
                if isPlayer1 == true then
                    --native.showAlert("test","Swiped Left Player1")
                else
                    --native.showAlert("test","Swiped Left Player2")
                    end
                end
            else
                totalSwipeDistanceRight = event.x - event.xStart
                if totalSwipeDistanceRight > minSwipeDistance then
                    if isPlayer1 == true then
                        --native.showAlert("test","Swiped Right Player1")
                    else
                        --native.showAlert("test","Swiped Right Player2")
                    end
                end
            end
        else
         if event.yStart > event.y then
                totalSwipeDistanceUp = event.yStart - event.y
                if totalSwipeDistanceUp > minSwipeDistance then
                    if isPlayer1 == true then
                        --native.showAlert("test","Player1 Attack")
                        playerB:activateBonus(-1)
                    end
                end
             else
                totalSwipeDistanceDown = event.y - event.yStart
                if totalSwipeDistanceDown > minSwipeDistance then
                   if isPlayer2 == true then
                        --native.showAlert("test","Player2 Attack")
                       playerT:activateBonus(1)
                   end
                end
             end
        end
    end
 end
 
 function swipe(event)
    if event.phase == "began" then
        bDoingTouch = true
        --beginX = event.x
        --beginY = event.y
     end
    if event.phase == "ended"  then
        --endX = event.x
        --endY = event.y
        checkSwipeDirection(event);
        bDoingTouch = false
    end
end

-- OBSTACLES
-- random obstacles
obstacles = nil
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
end

-- animation des obstacles existants
local function onEnterFrameObstacles(event)
    local velocity = 2
    for i, obstacle in ipairs(obstacles) do
        if (obstacle.x == nil) then
            --
        else
            if (obstacle.x < -80 or obstacle.y < 0) then
                obstacle:removeSelf()
                break
            end
            obstacle.x = obstacle.x - velocity
        end
    end
end

-- TAPIS ROULANT

local wheels = {}

local function createWheels(y)
    local width = display.viewableContentWidth;
    local nbWheels = 6
    local ratio = width / nbWheels
    local tapis = display.newImage("assets/tapis.png")
    level1Scene:insert(tapis)
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
    for i = 1, 6 do
        local xPosition = (ratio * i) - (ratio / 2)
        local wheel = display.newImage("assets/roue.png")
        wheel.x = xPosition
        wheel.width = 30
        wheel.height = 30
        -- random initial rotation
        wheel.rotation = math.random(0, 180)
        wheel.y = y
        table.insert(wheels, wheel)
        level1Scene:insert(wheel)
    end
    return tapis
end

local function onEnterFrameWheels()
    for i, wheel in ipairs(wheels) do
        local increment = -4
        if wheel.y < 100 then
            increment = 4
        end
        wheel.rotation = wheel.rotation + increment
    end
end

local function onEnterFrame(event)
    playerT:draw(event)
    playerB:draw(event)
end

local updateLastTime
local function mainUpdate()
    if gameIsOver then
        return
    end
    
    local time = system.getTimer()
    local seconds = time - updateLastTime
    updateLastTime = time
    playerT:update(seconds)
    playerB:update(seconds)

    WinnerPlayer, loserPlayer = someoneLost()
    if WinnerPlayer then
        loserPlayer.coronaObject:removeSelf()
        loserPlayer = nil
        storyboard.gotoScene("gameover", "fade", 500)
        gameIsOver = true
    end
end

-- Returns (Winner, Loser)
function someoneLost()
    if playerT.coronaObject.y < topGround.y then
        return playerB, playerT
    elseif playerB.coronaObject.y > ground.y then
        return playerT, playerB
    end
    return nil

end

function scene:enterScene(event)


    ObstacleTimer = timer.performWithDelay(500, obstacleTimer, 0)
    Runtime:addEventListener( "enterFrame", onEnterFrameObstacles)
    MainUpdateTimer = timer.performWithDelay( MAIN_UPDATE_DELAY, mainUpdate, 0 )

    Runtime:addEventListener( "enterFrame", onEnterFrameWheels)
    Runtime:addEventListener( "enterFrame", onEnterFrame)
end

-- Following methods are MANDATORY event if they are unused. Else it will not be recognized by the storyboard
function scene:createScene( event )
    updateLastTime = system.getTimer()
    print("createScene")
    gameIsOver = false
    level1Scene = self.view

    local plainBG = display.newRect(level1Scene, 0, 0, display.viewableContentWidth * 3, display.viewableContentHeight * 2)
    plainBG.x = 0
    plainBG.y = 0
    plainBG:setFillColor( 83, 71, 65)



    middleGround = display.newRect(0 ,0, display.viewableContentWidth * 3, 2);
    middleGround.x = 0
    middleGround.y = display.viewableContentHeight / 2 + 7
    middleGround:setFillColor ( 0, 0, 0  )


    setBackgrounds(level1Scene)
    playerB = Player.new("player", "Player 1", playerSpawn, PLAYER_BOTTOM_SPAWNY, 1, pW, pH)
    playerT = Player.new("player", "Player 2", playerSpawn, PLAYER_TOP_SPAWNY, -1, pW, pH)
    obstacles = {}
    bonusManager = BonusManager.new()
    bonusManager:initTimersAndListeners()

    background:addEventListener("touch", swipe)

    -- GROUNDS
    -- top wheels
    topTapis = createWheels(0)

    topGround = Ground.new()
    topGround = topGround:create(10, topTapis.contentWidth)
    topGround.width = topTapis.contentWidth

    -- bottom wheels
    bottomTapis = createWheels(display.viewableContentHeight)
    ground = Ground.new()
    ground = ground:create(display.viewableContentHeight - 10, bottomTapis.contentWidth)
    ground.width = bottomTapis.contentWidth

    Runtime:addEventListener ( "collision", onCollision )

    -- Only the background receives touches.
    background:addEventListener( "touch", onTouch)
end

function scene:exitScene( event )
    middleGround:removeSelf()
    timer.cancel(MainUpdateTimer)
    timer.cancel(ObstacleTimer)
    background:removeEventListener("touch", swipe)
    background:removeEventListener( "touch", onTouch)
    Runtime:removeEventListener ( "collision", onCollision )
    Runtime:removeEventListener( "enterFrame", onEnterFrameObstacles)
    Runtime:removeEventListener ( "enterFrame", onEnterFrameBG )
    Runtime:removeEventListener( "enterFrame", onEnterFrameWheels)


    Runtime:removeEventListener( "enterFrame", onEnterFrameObstacles)
--    Runtime:removeEventListener("enterFrame", ParticleHelper._onEnterFrame)

    bonusManager:cancelTimersAndListeners()
end

function scene:destroyScene( event )

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene