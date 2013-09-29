--
-- Project: SplitRunner
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
-- 
function setBackgrounds()
	--Globals
	backgroundSpeed = (.25)
	midBackgroundSpeed = (3)
		
	--load BGs images and set their positions
		local background = display.newImage("images/background.png")
	background:setReferencePoint(display.TopLeftReferencePoint)
    background.width = display.viewableContentWidth;
    background.height = display.viewableContentHeight;
    background.x = 0
    background.y = 0
	-- adding same backgrounds for infinity effect
	local background2 = display.newImage("images/background.png")
	background2:setReferencePoint(display.TopLeftReferencePoint)
    background2.width = display.viewableContentWidth;
    background2.height = display.viewableContentHeight;
    background2.x = background.width
    background2.y = 0
	local midBackground = display.newImage("assets/splitrunner-02.jpg")
	--3 backgrounds to be tablet compatible
	midBackground:setReferencePoint(display.TopLeftReferencePoint)
    midBackground.width = display.viewableContentWidth;
    midBackground.height = display.viewableContentHeight;
    midBackground.x = 0
    midBackground.y =0
	local midBackground2 = display.newImage("assets/splitrunner-02.jpg")
	midBackground2:setReferencePoint(display.TopLeftReferencePoint)
    midBackground2.width = display.viewableContentWidth;
    midBackground2.height = display.viewableContentHeight;
    midBackground2.x =  midBackground2.width
    midBackground2.y = 0
	local midBackground3 = display.newImage("assets/splitrunner-02.jpg")
	midBackground3:setReferencePoint(display.TopLeftReferencePoint)
    midBackground3.width = display.viewableContentWidth;
    midBackground3.height = display.viewableContentHeight;
    midBackground3.x =  midBackground3.width*2
    midBackground3.y = 0

	local function updateBackgrounds()
		--move backgrounds and reset positions when out of the screen
		background.x = background.x - backgroundSpeed
		if (background.x <= -background.width-backgroundSpeed) then
			background.x = background.width-backgroundSpeed
		end
		background2.x = background2.x - backgroundSpeed
		if (background2.x <= -background.width-backgroundSpeed) then
			background2.x = background.width-backgroundSpeed
		end
		midBackground.x = midBackground.x - midBackgroundSpeed
		if (midBackground.x <= -midBackground.width-midBackgroundSpeed) then
			midBackground.x = (midBackground.width*2)-midBackgroundSpeed
		end
		midBackground2.x = midBackground2.x - midBackgroundSpeed
		if (midBackground2.x <= -midBackground2.width-midBackgroundSpeed) then
			midBackground2.x = (midBackground2.width*2)-midBackgroundSpeed
		end
		midBackground3.x = midBackground3.x - midBackgroundSpeed
		if (midBackground3.x <= -midBackground3.width-midBackgroundSpeed) then
			midBackground3.x = (midBackground3.width*2)-midBackgroundSpeed
		end
	end

	local function update(event)
		updateBackgrounds()
	end

	local function onEnterFrame(e) 
		update()
	end
	--update background positions on each frame
	Runtime:addEventListener ( "enterFrame", onEnterFrame ) 
end