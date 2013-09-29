--
-- Project: SplitRunner
-- Description: 
--
-- Version: 1.0
-- Managed with http://CoronaProjectManager.com
--
-- Copyright 2013 . All Rights Reserved.
--

local background, background2, midBackground, midBackground2, midBackground3

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

function onEnterFrameBG(e)
    update()
end

function setBackgrounds(group)
	--Globals
	backgroundSpeed = (.25)
	midBackgroundSpeed = (.5)
		
	--load BGs images and set their positions
    local yOffset = 34
    background = display.newImage("assets/splitrunner-02.jpg")
    background.width = display.viewableContentWidth;
    background.height = display.viewableContentHeight * 0.8;
    background:setReferencePoint(display.TopLeftReferencePoint)
    background.x = 0
    background.y = yOffset
    group:insert(background)

	-- adding same backgrounds for infinity effect
	background2 = display.newImage("assets/splitrunner-02.jpg")
    background2.width = display.viewableContentWidth;
    background2.height = display.viewableContentHeight * 0.8;
    background2:setReferencePoint(display.TopLeftReferencePoint)
    background2.x = background.width
    background2.y = yOffset
    group:insert(background2)

    local ratio = 2
	midBackground = display.newImage("images/etageres.png")
	--3 backgrounds to be tablet compatible
    midBackground.alpha = 0.3
    midBackground.width = display.viewableContentWidth * ratio;
    midBackground.height = display.viewableContentHeight;
    midBackground:setReferencePoint(display.TopLeftReferencePoint)
    midBackground.x = 0
    midBackground.y = 0
    group:insert(midBackground)

	midBackground2 = display.newImage("images/etageres.png")
    midBackground2.alpha = 0.3
    midBackground2.width = display.viewableContentWidth * ratio;
    midBackground2.height = display.viewableContentHeight;
    midBackground2:setReferencePoint(display.TopLeftReferencePoint)
    midBackground2.x =  midBackground2.width
    midBackground2.y = 0
    group:insert(midBackground2)

	midBackground3 = display.newImage("images/etageres.png")
    midBackground3.alpha = 0.3
    midBackground3.width = display.viewableContentWidth * ratio;
    midBackground3.height = display.viewableContentHeight;
    midBackground3:setReferencePoint(display.TopLeftReferencePoint)
    midBackground3.x = midBackground3.width*2
    midBackground3.y = 0
    group:insert(midBackground3)
end