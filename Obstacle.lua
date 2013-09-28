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
    local targetY = display.viewableContentHeight / 2
    local random = math.random()
    if random > 0.5 then
        gravityScale = -1
        targetY = targetY - 40
    else
        targetY = targetY + 40
    end
    random = math.random()
    local isLarge = false
    local imageUrl = "assets/crate-"
    if random > 0.8 then
        isLarge = true
        imageUrl = imageUrl .. "large-"
    else
        imageUrl = imageUrl .. "small-"
    end
    random = math.random()
    if random > 0.5 then
        imageUrl  = imageUrl .. "dark"
    else
        imageUrl  = imageUrl .. "light"
    end
    local obstacle = display.newImage(imageUrl .. ".png")
    if (isLarge) then
        obstacle.width = 75
        obstacle.height = 40
    else
        obstacle.width = 40
        obstacle.height = 40
    end
    obstacle.x = display.viewableContentWidth + 40
    obstacle.y = targetY
    obstacle.rotation = math.random(0, 180)
    obstacle:setFillColor ( 122, 122, 122  )
    obstacle.objectType = "obstacle"
    physics.addBody( obstacle, "dynamic", { friction=1, bounce=0 } )
    obstacle.gravityScale = gravityScale
    return obstacle
end