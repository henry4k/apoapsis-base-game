--- @classmod base-game.Actor
--- Things that the player can take control of.
--
-- Extends @{core.world.WorldObject}.
--
-- Includes @{core.Controllable}.


local class = require 'middleclass'
local Vec   = require 'core/Vector'
local Mat4  = require 'core/Matrix4'
local Quat  = require 'core/Quaternion'
local Controllable        = require 'core/Controllable'
local WorldObject         = require 'core/world/WorldObject'
local CameraManifold      = require 'core/graphics/CameraManifold'
local EgoCameraController = require 'base-game/EgoCameraController'


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
    self.egoCameraController:addEventTarget('orientation-updated', self, self.orientationUpdated)

    self:orientationUpdated(self.egoCameraController:getOrientation())
end

function Actor:destroy()
    self.cameraManifold:destroy()
    self:destroyControllable()
    WorldObject.destroy(self)
end

local center  = Vec(0,0,0)
local forward = Vec(0,0,1)
local up      = Vec(0,1,0)

function Actor:orientationUpdated( orientation )
    local transformation = Mat4:lookAt(center,
                                       Quat:multiplyVector(orientation, forward),
                                       Quat:multiplyVector(orientation, up))
    -- Invert Z axis to remain in right-handed system.
    self.cameraManifold:setViewTransformation(transformation)
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
