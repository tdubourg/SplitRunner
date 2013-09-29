CBE=require("CBEffects.Library")

function getSmokeEffect(x, y)
    local smokeEffect=CBE.VentGroup{
        {
            preset="burn", -- Not the smoke preset because it's just about the same as the burn effect, just with a few changes
            title="smoke", -- The smoke vent
            color={{100}},
            parentGroup = level1Scene,
            build=function()
                local size=math.random(20, 20)
                return display.newImageRect("Textures/arrow_over.png", size, size)
            end,
            propertyTable={blendMode="screen"}, -- Lighten the comet slightly
            onCreation=function()end,
            perEmit=1,
            y=y,
            x=x,
            positionType="inRadius",
            posRadius=3,
            emitDelay=10,
            fadeInTime=200,
            lifeSpan=200,
            lifeStart=100,
            alpha=0.3,
            endAlpha=0,
            physics={
                sizeX=-1.01,
                sizeY=-0.61,
                autoAngle=false,
                angles={0},
                velocity=3,
                xDamping=1,
                gravityY=-0.01,
                gravityX=0.01
            }
        }
    }
    return smokeEffect
end

function getSparkEffect(x, y)
    local effect=CBE.VentGroup{
        {
            preset="sparks",
            title="explosion",
            parentGroup = level1Scene,
            build=function()
                local shape=display.newImageRect("Textures/generic_particle.png", 20, 30)
                shape:setReferencePoint(display.CenterLeftReferencePoint)
                return shape
            end,
            onCreation=function(particle)
                particle:applyForce((math.random(-10, 10)/500), (math.random(-10, 10)/500))
            end,
            y=y,
            x=x,
            color={{255, 255, 0}},
            posRadius=3,
            positionType="inRadius",
            perEmit=3,
            emitDelay=10,
            lifeSpan=50,
            onDeath=function()end,
            rotateTowardVel=true,
            physics={
                sizeY=-0.02,
                velocity=-8,
                gravityY=0.05,
                iterateAngle=false,
                autoAngle=true,
            }
        },
    }
    return effect
end

function getSmokeWallEffect(gravityScale)
    local yPosition = 0
    local angle = 265
    if gravityScale == 1 then
        yPosition = display.viewableContentHeight - 50
        angle = 100
    end
    local effect=CBE.VentGroup{
        {
            preset="burn", -- Not the smoke preset because it's just about the same as the burn effect, just with a few changes
            title="smoke", -- The smoke vent
            color={{255}},
            parentGroup = level1Scene,
            build=function()
                local size=math.random(120, 220)
                return display.newImageRect("Textures/smoke.png", size, size)
            end,
            propertyTable={blendMode="screen"}, -- Lighten the comet slightly
            onCreation=function()end,
            perEmit=4,
            positionType="inRect",
            rectLeft=0,
            rectTop=yPosition,
            rectWidth=display.contentWidth,
            rectHeight=100,
            posRadius=3,
            emitDelay=40,
            fadeInTime=100,
            lifeSpan=30,
            lifeStart=50,
            propertyTable={
                rotation=0
            },
            endAlpha=0,
            physics={
                autoAngle=false,
                angles={angle},
                velocity=5
            }
        }
    }
    return effect
end