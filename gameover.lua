local storyboard = require("storyboard")
local scene = storyboard.newScene()

local function onTouch(event)
    storyboard.removeScene("level1")
    storyboard.gotoScene("menu", "fade", 500)
    return true
end

POS_X_WIDGET_BUTTON = 0.3173958333333333
POS_Y_WIDGET_BUTTON = 0.6907407407407407
WIDTH_RATIO_WIDGET_BUTTON = 0.4182291666666667
HEIGHT_RATIO_WIDGET_BUTTON = 0.1861111111111111

function scene:enterScene(event)
    local group = self.view

    -- display a background image
    local background = display.newImageRect("images/startscreen.png", display.contentWidth, display.contentHeight)
    background:setReferencePoint(display.TopLeftReferencePoint)
    background.x, background.y = 0, 0
    background:addEventListener("touch", onTouch);

    local myText = display.newText(group,
        WinnerPlayer.name .. " WINS",
        0,
        200,
        native.systemFont,
        25)
    myText:setTextColor(66, 33, 11)
    myText:setReferencePoint( display.TopLeftReferencePoint )
    myText.x = display.contentWidth*POS_X_WIDGET_BUTTON
    myText.y = display.contentHeight*POS_Y_WIDGET_BUTTON
    WinnerPlayer.coronaObject:removeSelf()
    WinnerPlayer = nil
    group:insert(background)
    group:insert(myText)
end


-- Following methods are MANDATORY event if they are unused. Else it will not be recognized by the storyboard

function scene:createScene(event)
end

function scene:exitScene(event)
end

function scene:destroyScene(event)
end

scene:addEventListener("createScene", scene)
scene:addEventListener("enterScene", scene)
scene:addEventListener("exitScene", scene)
scene:addEventListener("destroyScene", scene)

return scene