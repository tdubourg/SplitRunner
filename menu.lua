local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

-- include Corona's "widget" library
local widget = require "widget"

-- forward declarations and other locals
local playBtn

-- 'onRelease' event listener for playBtn
local function onPlayBtnRelease()
	
	-- go to level1.lua scene
	storyboard.gotoScene( "level1", "fade", 500 )

	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function onCreditsBtnRelease()

	-- go to level1.lua scene
	storyboard.gotoScene( "thecredits", "fade", 500 )
--	storyboard.gotoScene( "credits", "fade", 500 )

	return true	-- indicates successful touch
end


-- Those constants are the ratio of the sizes and positions of the widget button relative to the full sized-background,
-- As the background is going to be scaled, using the ratio, and multiplying by the contentWidth/contentHeight, we're
-- going to place them at the exact location where they should be
POS_X_WIDGET_BUTTON = 0.2973958333333333
POS_Y_WIDGET_BUTTON = 0.6407407407407407
WIDTH_RATIO_WIDGET_BUTTON = 0.4182291666666667
HEIGHT_RATIO_WIDGET_BUTTON = 0.2

function scene:createScene( event )
	local group = self.view

	-- display a background image
	local background = display.newImageRect( "images/startscreen.png", display.contentWidth, display.contentHeight )
	background:setReferencePoint( display.TopLeftReferencePoint )
	background.x, background.y = 0, 0

	-- create a widget button (which will loads level1.lua on release)
	playBtn = widget.newButton{
		label="",
		labelColor = { default={255}, over={128} },
		defaultFile="images/play-button-startscreen.png",
		overFile="images/play-button-startscreen-mouseover.png",
		width=250, height=HEIGHT_RATIO_WIDGET_BUTTON*display.contentHeight,
		onRelease = onPlayBtnRelease	-- event listener function
	}
	playBtn:setReferencePoint( display.TopLeftReferencePoint )
	playBtn.x = display.contentWidth*POS_X_WIDGET_BUTTON - 30
	playBtn.y = display.contentHeight*POS_Y_WIDGET_BUTTON

	creditsBtn = widget.newButton{
		label="credits",
		labelColor = { default={66, 33, 11}, over={128} },
        textOnly = true,
		width=0.078125*display.contentWidth, height=0.0462962962962963*display.contentHeight,
		onRelease = onCreditsBtnRelease	-- event listener function
	}
	creditsBtn:setReferencePoint( display.TopLeftReferencePoint )
	creditsBtn.x = 0.435*display.contentWidth
	creditsBtn.y = 0.86*display.contentHeight
	
	-- all display objects must be inserted into group
	group:insert( background )
	group:insert( playBtn )
	group:insert( creditsBtn )
end

-- Called immediately after scene has moved onscreen:
function scene:enterScene( event )
	local group = self.view
end

-- Called when scene is about to move offscreen:
function scene:exitScene( event )
	local group = self.view
end

-- If scene's view is removed, scene:destroyScene() will be called just prior to:
function scene:destroyScene( event )
	local group = self.view

    background:removeSelf()
    background = nil
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end

    if creditsBtn then
        creditsBtn:removeSelf()	-- widgets must be manually removed
        creditsBtn = nil
	end
end

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


return scene