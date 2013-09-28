local physics = require( "physics" )

Obstacle = {}

Obstacle.__index = Obstacle

function Obstacle.new(args) -- constructor
    local self = {}
    setmetatable(self, Obstacle)
    return self
end

function Obstacle:create()
    local gravityScale = 1
    local random = math.random()
    if random > 0.5 then
        gravityScale = -1
    end
    local obstacle = display.newRect(0 ,0, 20, 20);

    obstacle.x = display.viewableContentWidth
    obstacle.y = display.viewableContentHeight / 2
    obstacle:setFillColor ( 122, 122, 122  )
    obstacle.objectType = "obstacle"
    physics.addBody( obstacle, "dynamic", { friction=1, bounce=0 } )
    obstacle.gravityScale = gravityScale
    return obstacle
end