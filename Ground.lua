local physics = require( "physics" )

Ground = {}

Ground.__index = Ground

function Ground.new(args) -- constructor
    local self = {}
    setmetatable(self, Ground)
    return self
end

function Ground:create(y)
    local groundHeight = 10
    local object = display.newRect(0 ,0, display.viewableContentWidth, groundHeight);
    object.y = y
    object:setFillColor ( 255, 0, 0  )
    object.objectType = "ground"
    physics.addBody( object, "static", { friction=0.5, bounce=0.3 } )
    return object
end