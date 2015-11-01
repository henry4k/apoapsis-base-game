--- @classmod base-game.world.HumanoidActor
--- Base class for humanoid actors.
--
-- Extends @{base-game.world.PhysicalActor}.


local class  = require 'middleclass'
local Vec    = require 'core/Vector'
local Quat   = require 'core/Quaternion'
local CapsuleCollisionShape = require 'core/physics/CapsuleCollisionShape'
local Solid                 = require 'core/physics/Solid'
local PhysicalActor         = require 'base-game/world/PhysicalActor'


local HumanoidActor = class('base-game/world/HumanoidActor', PhysicalActor)


function HumanoidActor:initialize( renderTarget )
    local collisionShape = CapsuleCollisionShape(0.5, 2)
    local solid = Solid(1, Vec(0,0,0), Quat(), collisionShape)

    PhysicalActor.initialize(self, renderTarget, solid)
end

function HumanoidActor:destroy()
    PhysicalActor.destroy(self)
end


return HumanoidActor
