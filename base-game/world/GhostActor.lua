--- @classmod base-game.world.GhostActor
--
-- Extends @{base-game.world.PhysicalActor}.


local class  = require 'middleclass'
local Vec    = require 'core/Vector'
local Quat   = require 'core/Quaternion'
local Timer  = require 'core/Timer'
local EmptyCollisionShape = require 'core/physics/EmptyCollisionShape'
local Solid               = require 'core/physics/Solid'
local PhysicalActor       = require 'base-game/world/PhysicalActor'


local GhostActor = class('base-game/world/GhostActor', PhysicalActor)


function GhostActor:initialize( renderTarget )
    local collisionShape = EmptyCollisionShape()
    local solid = Solid(1, Vec(0,0,0), Quat(), collisionShape)
    solid:enableGravity(false)

    self.relativeMovementDirection = Vec(0,0,0)
    self.movementForce = nil

    PhysicalActor.initialize(self, renderTarget, solid)
end

function GhostActor:destroy()
    PhysicalActor.destroy(self)
end

function GhostActor:_updateMovementForce()
    local orientation = self.egoCameraController:getOrientation()
    local absoluteMovementDirection =
        Quat:multiplyVector(orientation, self.relativeMovementDirection)
    local forceValue = absoluteMovementDirection * 100
    local force = self.movementForce

    if forceValue:length() > 0.01 then
        if not force then
            self:stopDecelerating()
            force = self.solid:createForce()
            self.movementForce = force
        end
        force:set(forceValue, nil, true)
    else
        if force then
            force:destroy()
            self.movementForce = nil
            self:startDecelerating()
        end
    end
end

function GhostActor:_orientationUpdated( orientation )
    PhysicalActor._orientationUpdated(self, orientation)
    self:_updateMovementForce()
end

-- @control forward
GhostActor:mapControl('forward', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[3] = 1
    else
        self.relativeMovementDirection[3] = 0
    end
    self:_updateMovementForce()
end)

-- @control backward
GhostActor:mapControl('backward', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[3] = -1
    else
        self.relativeMovementDirection[3] = 0
    end
    self:_updateMovementForce()
end)

-- @control left
GhostActor:mapControl('left', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[1] = 1
    else
        self.relativeMovementDirection[1] = 0
    end
    self:_updateMovementForce()
end)

-- @control right
GhostActor:mapControl('right', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[1] = -1
    else
        self.relativeMovementDirection[1] = 0
    end
    self:_updateMovementForce()
end)

-- @control up
GhostActor:mapControl('up', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[2] = 1
    else
        self.relativeMovementDirection[2] = 0
    end
    self:_updateMovementForce()
end)

-- @control down
GhostActor:mapControl('down', function( self, absolute, delta )
    if delta > 0 then
        self.relativeMovementDirection[2] = -1
    else
        self.relativeMovementDirection[2] = 0
    end
    self:_updateMovementForce()
end)

function GhostActor:startDecelerating()
    local force = self.decelerationForce
    if not force then
        force = self.solid:createForce()
        self.decelerationForce = force
    end

    local timer = self.decelerationTimer
    if not timer then
        timer = Timer(0.5, self, self._updateDecelerationForce)
        self.decelerationTimer = timer
    end

    self:_updateDecelerationForce()
end

function GhostActor:stopDecelerating()
    if self.decelerationForce then
        self.decelerationForce:destroy()
        self.decelerationForce = nil
    end

    if self.decelerationTimer then
        self.decelerationTimer:destroy()
        self.decelerationTimer = nil
    end
end

function GhostActor:_updateDecelerationForce()
    local force = self.decelerationForce
    assert(force)

    local velocity = self.solid:getLinearVelocity()
    force:set(-velocity*100)
end


return GhostActor
