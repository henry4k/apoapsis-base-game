local Vec    = require 'core/Vector'
local Mat4   = require 'core/Matrix4'
local Skybox = require 'base-game/Skybox/init'
local Planet = require 'base-game/Planet/init'


local Background = {}

function Background.setup( renderTarget )
    local backgroundCamera     = renderTarget:getCameraByName('background')
    local backgroundModelWorld = backgroundCamera:getModelWorld()

    backgroundCamera:setNearAndFarPlanes(10, 100000)

    local skybox = Skybox(backgroundModelWorld)
    skybox.model:setTransformation(Mat4():scale(90000))

    local planet = Planet(backgroundModelWorld)
    local planetDiameter = 12756
    local meterAboveSurface = 1200
    local planetTransformation = Mat4():translate(Vec(0,0,(planetDiameter/2)+meterAboveSurface))
                                       :scale(planetDiameter)
    planet:setTransformation(planetTransformation)
end


return Background
