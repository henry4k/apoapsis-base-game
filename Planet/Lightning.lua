local class   = require 'middleclass'
local Vec     = require 'core/Vector'
local Mat4    = require 'core/Matrix4'
local Mesh    = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


--local lightningMesh = Mesh:load('base-game/Planet/Scene.json', 'Icosphere')
local lightningMesh = Mesh:load('base-game/Planet/Scene.json', 'LightningParticleDummy')
local cloudTexture = Texture:load('2d', 'base-game/Planet/Surface.png', {'filter'})


local Lightning = class('base-game/Planet/Lightning')

function Lightning:initialize( modelWorld )
    self.model = modelWorld:createModel('background')
    self.model:setMesh(lightningMesh)
    self.model:setProgramFamily('planet-lightning')
    self.model:setTexture(0, cloudTexture)
    self.model:setUniform('CloudSampler', 0, 'int')
    self:setTransformation(Mat4())
end

function Lightning:setTransformation( transformation )
    self.model:setTransformation(transformation)
end

return Lightning
