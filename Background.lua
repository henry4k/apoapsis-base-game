local Vec    = require 'core/Vector'
local Mat4   = require 'core/Matrix4'
local Skybox = require 'base-game/Skybox/init'
local Planet = require 'base-game/Planet/init'


local Background = {}

function Background.setup( renderTarget )
    local backgroundCamera     = renderTarget:getCameraByName('world')
    local backgroundModelWorld = backgroundCamera:getModelWorld()

    local skybox = Skybox(backgroundModelWorld)
    --skybox.model:setTransformation(Mat4():scale(99999*1000))
    skybox.model:setTransformation(Mat4():scale(50))

    local planet = Planet(backgroundModelWorld)
    local planetDiameter = 1 -- 12756 * 1000
    local meterAboveSurface = 1 -- 400 * 1000
    local planetTransformation = Mat4():translate(Vec(0,0,planetDiameter+meterAboveSurface))
                                       :scale(planetDiameter*2)
                                       --:rotate(math.rad(90), Vec(1,0,0))
    planet:setTransformation(planetTransformation)
end


return Background
