--- @classmod base-game.Actor
--- Things that the player can take control of.
--
-- Extends @{core.world.WorldObject}.
--
-- Includes @{core.Controllable}.


local class  = require 'middleclass'
local Vec    = require 'core/Vector'
local Control             = require 'core/Control'
local Controllable        = require 'core/Controllable'
local WorldObject         = require 'core/world/WorldObject'
local CameraManifold      = require 'core/graphics/CameraManifold'
local EgoCameraController = require 'core/EgoCameraController'


local DefaultFoV = math.rad(80)
local ZoomedFoV  = math.rad(10)


local Actor = class('base-game/Actor', WorldObject)
Actor:include(Controllable)


---
-- You probably want to extend this class, since it isn't of much use on itself.
-- @param[type=core.graphics.RenderTarget] renderTarget
--
function Actor:initialize( renderTarget )
    WorldObject.initialize(self)
    self:initializeControllable()

    self.cameraManifold = CameraManifold(renderTarget)
    self.cameraManifold:setFieldOfView(DefaultFoV)

    self.egoCameraController = EgoCameraController()
    self:setChildControllables({self.egoCameraController})
    local function onOrientationUpdated( self, orientation )
        local transformation = orientation:toMatrix():scale(Vec(1,1,-1))
        -- Invert Z axis to remain in right-handed system.
        self.cameraManifold:setViewTransformation(transformation)
    end
    self.egoCameraController:addEventTarget('orientation-updated', self, onOrientationUpdated)

    onOrientationUpdated(self, self.egoCameraController:getOrientation())
end

function Actor:destroy()
    self.cameraManifold:destroy()
    self:destroyControllable()
    WorldObject.destroy(self)
end

--- While pressed, the field of view set to a smaller value.
-- @control zoom
Actor:mapControl('zoom', function( self, absolute, delta )
    if delta > 0 then
        self.cameraManifold:setFieldOfView(ZoomedFoV)
    else
        self.cameraManifold:setFieldOfView(DefaultFoV)
    end
end)


return Actor
