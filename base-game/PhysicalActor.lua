--- @classmod base-game.PhysicalActor
--- Actor which exists in the physical world.
--
-- Extends @{base-game.Actor}.


local class  = require 'middleclass'
local Vec    = require 'core/Vector'
local Quat   = require 'core/Quaternion'
local CapsuleCollisionShape = require 'core/physics/CapsuleCollisionShape'
local Solid                 = require 'core/physics/Solid'
local Actor                 = require 'base-game/Actor'


local PhysicalActor = class('base-game/PhysicalActor', Actor)


function PhysicalActor:initialize( renderTarget, solid )
    Actor.initialize(self, renderTarget)

    self.solid = solid
    self.relativeForceValue = Vec(0,0,0)
    self.relativeForce = nil

    self.cameraManifold:setAttachmentTarget(solid)
end

function PhysicalActor:destroy()
    self.solid:destroy()
    Actor.destroy(self)
end

function PhysicalActor:addRelativeForce( v )
    local value = self.relativeForceValue
    local force = self.relativeForce

    value = value + v*100
    if value:length() > 0.01 then
        if not force then
            force = self.solid:createForce()
            self.relativeForce = force
        end
        force:set(value, nil, true)
    else
        if force then
            force:destroy()
            self.relativeForce = nil
        end
    end

    self.relativeForceValue = value
end

-- @control forward
PhysicalActor:mapControl('forward', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(0,0,1))
    else
        self:addRelativeForce(Vec(0,0,-1))
    end
end)

-- @control backward
PhysicalActor:mapControl('backward', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(0,0,-1))
    else
        self:addRelativeForce(Vec(0,0,1))
    end
end)

-- @control left
PhysicalActor:mapControl('left', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(-1,0,0))
    else
        self:addRelativeForce(Vec(1,0,0))
    end
end)

-- @control right
PhysicalActor:mapControl('right', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(1,0,0))
    else
        self:addRelativeForce(Vec(-1,0,0))
    end
end)

-- @control up
PhysicalActor:mapControl('up', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(0,1,0))
    else
        self:addRelativeForce(Vec(0,-1,0))
    end
end)

-- @control down
PhysicalActor:mapControl('down', function( self, absolute, delta )
    if delta > 0 then
        self:addRelativeForce(Vec(0,-1,0))
    else
        self:addRelativeForce(Vec(0,1,0))
    end
end)

---- @control jump
--PhysicalActor:mapControl('jump', function( self, absolute, delta )
--    if delta > 0 then
--        self.solid:applyImpulse(Vec(0,1,0)*0.5, nil, true)
--    end
--end)


return PhysicalActor
