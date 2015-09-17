local class   = require 'middleclass'
local Mesh    = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


local planetMesh = Mesh:load('base-game/Planet/Scene.json', 'Icosphere')
local planetSurfaceTexture  = Texture:load('2d', 'base-game/Planet/Surface.png', {'filter'})
local planetMaterialTexture = Texture:load('2d', 'base-game/Planet/Material.png', {'filter', 'clamp'})


local Planet = class('base-game/Planet')

function Planet:initialize( modelWorld )
    self.model = modelWorld:createModel('background')
    self.model:setMesh(planetMesh)
    self.model:setProgramFamily('planet')
    self.model:setTexture(0, planetSurfaceTexture)
    self.model:setTexture(1, planetMaterialTexture)
    self.model:setUniform('SurfaceSampler', 0, 'int')
    self.model:setUniform('MaterialSampler',  1, 'int')
end

function Planet:setTransformation( transformation )
    self.model:setTransformation(transformation)
end

return Planet
