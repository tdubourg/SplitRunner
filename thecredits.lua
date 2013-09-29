local storyboard = require( "storyboard" )
local scene = storyboard.newScene()

--local function onTouch( event )
--    storyboard.gotoScene( "menu", "fade", 500 )
--    return true
--end

function scene:enterScene( event )
    local group = self.view

    -- display a background image
    local background = display.newImageRect( "images/credits.png", display.contentWidth, display.contentHeight )
    background:setReferencePoint( display.TopLeftReferencePoint )
    background.x, background.y = 0, 0
----    background:addEventListener("touch", onTouch);
--
--    group:insert( background )
end


-- Following methods are MANDATORY event if they are unused. Else it will not be recognized by the storyboard

function scene:createScene( event )

end

function scene:exitScene( event )

end

function scene:destroyScene( event )

end

scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
scene:addEventListener( "destroyScene", scene )

return scene