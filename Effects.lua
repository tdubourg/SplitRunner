CBE=require("CBEffects.Library")

function getSmokeEffect(x, y)
    local smokeEffect=CBE.VentGroup{
        {
            preset="burn", -- Not the smoke preset because it's just about the same as the burn effect, just with a few changes
            title="smoke", -- The smoke vent
            color={{100}},
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