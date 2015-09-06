--- @classmod base-game.world.PhysicalActor
--- Actor which exists in the physical world.
--
-- Extends @{base-game.world.Actor}.


local class = require 'middleclass'
local Actor = require 'base-game/world/Actor'


local PhysicalActor = class('base-game/world/PhysicalActor', Actor)


function PhysicalActor:initialize( renderTarget, solid )
    self.solid = solid

    Actor.initialize(self, renderTarget)

    self.cameraManifold:setAttachmentTarget(solid)
end

function PhysicalActor:destroy()
    self.solid:destroy()
    Actor.destroy(self)
end


return PhysicalActor
