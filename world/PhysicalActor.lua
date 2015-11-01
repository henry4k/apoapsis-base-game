--- @classmod base-game.world.PhysicalActor
--- Actor which exists in the physical world.
--
-- Extends @{base-game.world.Actor}.


local class = require 'middleclass'
local Actor = require 'base-game/world/Actor'
local SolidChunkActivator = require 'core/voxel/SolidChunkActivator'


local PhysicalActor = class('base-game/world/PhysicalActor', Actor)


function PhysicalActor:initialize( renderTarget, solid )
    self.solid = solid
    self.chunkActivator = SolidChunkActivator(solid, 8)

    Actor.initialize(self, renderTarget)

    self.cameraManifold:setAttachmentTarget(solid)
end

function PhysicalActor:destroy()
    self.solid:destroy()
    Actor.destroy(self)
end


return PhysicalActor
