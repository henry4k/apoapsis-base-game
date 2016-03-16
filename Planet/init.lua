local class   = require 'middleclass'
local Vec     = require 'core/Vector'
local Mat4    = require 'core/Matrix4'
local Timer   = require 'core/Timer'
local Mesh    = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


local planetMesh = Mesh:load('base-game/Planet/Scene.json', 'Icosphere')
local planetSurfaceTexture  = Texture:load{fileName='base-game/Planet/Surface.png',  colorSpace='srgb'}
local planetAlbedoTexture   = Texture:load{fileName='base-game/Planet/Albedo.png',   colorSpace='srgb', wrapMode='clamp'}
local planetSpecularTexture = Texture:load{fileName='base-game/Planet/Specular.png', colorSpace='srgb', wrapMode='clamp'}

local cloudTexture = Texture:load{fileName='base-game/Planet/Clouds.png'}


local Planet = class('base-game/Planet')

function Planet:initialize( modelWorld )
    self.model = modelWorld:createModel()
    self.model:setMesh(planetMesh)
    self.model:setProgramFamily('planet')
    self.model:setTexture(0, planetSurfaceTexture)
    self.model:setTexture(1, planetAlbedoTexture)
    self.model:setTexture(2, planetSpecularTexture)
    self.model:setTexture(3, cloudTexture)
    self.model:setUniform('SurfaceSampler',  0, 'int')
    self.model:setUniform('AlbedoSampler',   1, 'int')
    self.model:setUniform('SpecularSampler', 2, 'int')
    self.model:setUniform('CloudSampler',    3, 'int')

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

local planetRadPerSecond = (2*math.pi) / (24*60*60)
local stationRadPerSecond = (2*math.pi) / (93*60)
local radPerSecond = planetRadPerSecond + stationRadPerSecond

function Planet:_updateTransformation( timeDelta )
    local rotation = self.rotation
    local transformation = self.transformation:clone()
    transformation = transformation:rotate(rotation, Vec(0,1,0))

    self.model:setTransformation(transformation)
    self.cloudModel:setTransformation(transformation)

    self.rotation = rotation - timeDelta*radPerSecond
end

return Planet
