--- @classmod base-game.GhostActor
--
-- Extends @{base-game.PhysicalActor}.


local class  = require 'middleclass'
local Vec    = require 'core/Vector'
local Quat   = require 'core/Quaternion'
local EmptyCollisionShape = require 'core/physics/EmptyCollisionShape'
local Solid               = require 'core/physics/Solid'
local PhysicalActor       = require 'base-game/PhysicalActor'


local GhostActor = class('base-game/GhostActor', PhysicalActor)


function GhostActor:initialize( renderTarget )
    local collisionShape = EmptyCollisionShape()
    local solid = Solid(1, Vec(0,0,0), Quat(), collisionShape)
    solid:enableGravity(false)

    PhysicalActor.initialize(self, renderTarget, solid)
end

function GhostActor:destroy()
    PhysicalActor.destroy(self)
end


return GhostActor
