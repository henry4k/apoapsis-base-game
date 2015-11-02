local class   = require 'middleclass'
local Vec     = require 'core/Vector'
local Mat4    = require 'core/Matrix4'
local Timer   = require 'core/Timer'
local Mesh    = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


local planetMesh = Mesh:load('base-game/Planet/Scene.json', 'Icosphere')
local planetSurfaceTexture  = Texture:load('2d', 'base-game/Planet/Surface.png', {'filter'})
local planetAlbedoTexture   = Texture:load('2d', 'base-game/Planet/Albedo.png', {'filter', 'clamp'})
local planetSpecularTexture = Texture:load('2d', 'base-game/Planet/Specular.png', {'filter', 'clamp'})

local cloudTexture = Texture:load('2d', 'base-game/Planet/Clouds.png', {'filter'})


local Planet = class('base-game/Planet')

function Planet:initialize( modelWorld )
    self.model = modelWorld:createModel('background')
    self.model:setMesh(planetMesh)
    self.model:setProgramFamily('planet')
    self.model:setTexture(0, planetSurfaceTexture)
    self.model:setTexture(1, planetAlbedoTexture)
    self.model:setTexture(2, planetSpecularTexture)
    self.model:setUniform('SurfaceSampler',  0, 'int')
    self.model:setUniform('AlbedoSampler',   1, 'int')
    self.model:setUniform('SpecularSampler', 2, 'int')

    self.cloudModel = modelWorld:createModel('background')
    self.cloudModel:setOverlayLevel(1)
    self.cloudModel:setMesh(planetMesh)
    self.cloudModel:setProgramFamily('planet-atmosphere')
    self.cloudModel:setTexture(0, cloudTexture)
    self.cloudModel:setUniform('CloudSampler', 0, 'int')

    self.rotation = 0
    self:setTransformation(Mat4())
    self.timer = Timer(0, self, self._updateTransformation)
end

function Planet:setTransformation( transformation )
    self.transformation = transformation
    self:_updateTransformation(0)
end

function Planet:_updateTransformation( timeDelta )
    local rotation = self.rotation
    local transformation = self.transformation:clone()
    transformation = transformation:rotate(rotation, Vec(0,1,0))

    self.model:setTransformation(transformation)
    self.cloudModel:setTransformation(transformation)

    self.rotation = rotation + math.rad(5*timeDelta)
end

return Planet