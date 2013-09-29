local physics = require( "physics" )

Ground = {}

Ground.__index = Ground

function Ground.new(args) -- constructor
    local self = {}
    setmetatable(self, Ground)
    return self
end

function Ground:create(y, width)
    local groundHeight = 10
    local object = display.newRoundedRect(groundHeight*2/3, 0, width-groundHeight*4/3, groundHeight, groundHeight/5);
    object.y = y
    object:setFillColor ( 255, 0, 0 , 0 )
    object.objectType = "ground"
    physics.addBody( object, "static", { friction=0.5, bounce=0.2 } )
    level1Scene:insert(object)
    return object
end