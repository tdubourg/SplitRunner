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
--load BGs images and set their positions
local background = display.newImage("images/background.png")background.x = 240background.y = 160local midBackground = display.newImage("images/bgfar1.png")midBackground.x = 480midBackground.y = 160local function updateBackgrounds()	--move backgrounds	background.x = background.x - (.25)	midBackground.x = midBackground.x - 3endlocal function update(event)	updateBackgrounds()end-- call Update every 1 ms for an unlimited amount of time thanks to -1timer.performWithDelay(1, update, -1)

