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

system.activate("multitouch")
print(display.contentWidth)print(display.contentScaleX)print(display.viewableContentWidth)--load BGs images and set their positions
local background = display.newImage("images/background.png")background.x = display. contentWidth/2background.y = display.contentHeight/2-- adding same backgrounds for infinity effectlocal background2 = display.newImage("images/background.png")background2.x = display.contentWidthbackground2.y = display.contentHeight/2local midBackground = display.newImage("images/bgfar1.png")--3 backgrounds to be tablet compatiblemidBackground:setReferencePoint(display.TopLeftReferencePoint)midBackground.x = 0midBackground.y =0local midBackground2 = display.newImage("images/bgfar1.png")midBackground2:setReferencePoint(display.TopLeftReferencePoint)midBackground2.x =  midBackground2.widthmidBackground2.y = 0local midBackground3 = display.newImage("images/bgfar1.png")midBackground3:setReferencePoint(display.TopLeftReferencePoint)midBackground3.x =  midBackground3.width*2midBackground3.y = 0local function updateBackgrounds()	--move backgrounds and reset positions when out of the screen	background.x = background.x - (.25)	if (background.x == 0) then		background.x = display.contentWidth	end	background2.x = background2.x - (.25)	if (background2.x == 0) then		background2.x = display.contentWidth	end	midBackground.x = midBackground.x - 3	if (midBackground.x <= -midBackground.width-3) then		midBackground.x = (midBackground.width*2)-3	end	midBackground2.x = midBackground2.x - 3	if (midBackground2.x <= -midBackground2.width-3) then		midBackground2.x = (midBackground2.width*2)-3	end	midBackground3.x = midBackground3.x - 3	if (midBackground3.x <= -midBackground3.width-3) then		midBackground3.x = (midBackground3.width*2)-3	endendlocal function update(event)	updateBackgrounds()endlocal function onEnterFrame(e) 	update()end--update background positions on each frameRuntime:addEventListener ( "enterFrame", onEnterFrame ) 

