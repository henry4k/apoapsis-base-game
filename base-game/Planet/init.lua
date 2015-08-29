local class   = require 'middleclass'
local Mesh    = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


local planetMesh = Mesh:load('base-game/Planet/Scene.json', 'Icosphere')
local earthDiffuseTexture = Texture:load('2d', 'base-game/Planet/EarthDiffuse.png', {'filter'})
local earthNormalTexture  = Texture:load('2d', 'base-game/Planet/EarthNormal.png', {'filter'})
local cloudDiffuseTexture = Texture:load('2d', 'base-game/Planet/EarthCloudDiffuse.png',  {'filter'})
local cloudNormalTexture  = Texture:load('2d', 'base-game/Planet/EarthCloudNormal.png',  {'filter'})


local Planet = class('example/Planet')

function Planet:initialize( modelWorld )
    self.model = modelWorld:createModel('background')
    self.model:setMesh(planetMesh)
    self.model:setProgramFamily('planet')
    self.model:setTexture(0, earthDiffuseTexture)
    self.model:setTexture(1, earthNormalTexture)
    self.model:setTexture(2, cloudDiffuseTexture)
    self.model:setUniform('DiffuseSampler', 0, 'int')
    self.model:setUniform('NormalSampler',  1, 'int')
    self.model:setUniform('CloudSampler',   2, 'int')

    self.cloudModel = modelWorld:createModel('background')
    self.cloudModel:setMesh(planetMesh)
    self.cloudModel:setProgramFamily('planet-clouds')
    self.cloudModel:setTexture(0, cloudDiffuseTexture)
    self.cloudModel:setTexture(1, cloudNormalTexture)
    self.cloudModel:setUniform('DiffuseSampler', 0, 'int')
    self.cloudModel:setUniform('NormalSampler',  1, 'int')
end

function Planet:setTransformation( transformation )
    self.model:setTransformation(transformation)
    self.cloudModel:setTransformation(transformation:scale(1.01))
end

return Planet
