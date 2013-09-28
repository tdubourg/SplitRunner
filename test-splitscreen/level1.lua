-----------------------------------------------------------------------------------------
--
-- level1.lua
--
-----------------------------------------------------------------------------------------

local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "physics" library
local physics = require "physics"
physics.start()
physics.setDrawMode("hybrid")
--------------------------------------------

-- forward declarations and other locals
local screenW, screenH, halfW = display.contentWidth, display.contentHeight, display.contentWidth*0.5
PLAYER_H, PLAYER_W = 50, 50
-----------------------------------------------------------------------------------------
-- BEGINNING OF YOUR IMPLEMENTATION
-- 
-- NOTE: Code outside of listener functions (below) will only be executed once,
--		 unless storyboard.removeScene() is called.
-- 
-----------------------------------------------------------------------------------------


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
    
    physics.addBody(displayObject, "dynamic", { friction = 1, density=1.0, shape = {
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
end

-- Called when the scene's view does not exist:
function scene:createScene( event )
	local group = self.view

	-- create a grey rectangle as the backdrop
	local background = display.newRect( 0, 0, screenW, screenH )
	background:setFillColor( 128 )

	-- create a grass object and add physics (with custom shape)
	local grass1 = display.newImageRect( "player.png", PLAYER_W, PLAYER_H)
	grass1:setReferencePoint( display.BottomLeftReferencePoint )
	grass1.x, grass1.y = 1, display.contentHeight-100
    addBodyWithCutCornersRectangle(grass1, 30)
--	local grass = display.newImageRect( "grass-top.png", screenW, 82 )
--	grass:setReferencePoint( display.TopLeftReferencePoint)
--	grass.x, grass.y = 0, 200

	local myText = display.newText(
        group,
        "contentHeight, contentWidht = " .. display.contentHeight .. ", " .. display.contentWidth,
        0,
        200,
        native.systemFont,
        16
    )
    myText:setTextColor(0,255,0)
    myText:setReferencePoint(display.TopLeftReferencePoint)

    local ground = display.newRect(0, display.contentHeight-10, display.contentWidth, 10)
    ground:setFillColor(0, 0, 255)
    physics.addBody(ground, "static", {friction = 0, density=1.0})

    local obs = display.newRect(50, display.contentHeight-10-20, 100, 20)
    physics.addBody(obs, "static", {friction = 0, density=1.0})
    obs:setFillColor(0, 0, 255)


	-- all display objects must be inserted into group
	group:insert( background )
    group:insert( ground )
    group:insert( obs )
--	group:insert( grass )
	group:insert( grass1 )
    group:insert( myText )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
	
	physics.start()
	
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
	
	physics.stop()
	
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view
	
	package.loaded[physics] = nil
	physics = nil
end

-----------------------------------------------------------------------------------------
-- END OF YOUR IMPLEMENTATION
-----------------------------------------------------------------------------------------

-- "createScene" event is dispatched if scene's view does not exist
scene:addEventListener( "createScene", scene )

-- "enterScene" event is dispatched whenever scene transition has finished
scene:addEventListener( "enterScene", scene )

-- "exitScene" event is dispatched whenever before next scene's transition begins
scene:addEventListener( "exitScene", scene )

-- "destroyScene" event is dispatched before view is unloaded, which can be
-- automatically unloaded in low memory situations, or explicitly via a call to
-- storyboard.purgeScene() or storyboard.removeScene().
scene:addEventListener( "destroyScene", scene )

-----------------------------------------------------------------------------------------

return scene