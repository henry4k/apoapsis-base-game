local class = require 'middleclass'
local Mesh  = require 'core/graphics/Mesh'
local Texture = require 'core/graphics/Texture'


local skyboxMesh = Mesh:load('base-game/Skybox/Scene.json', 'Skybox')
local skyboxDiffuseTexture = Texture:load{target='cube', fileName='base-game/Skybox/%s.png', colorSpace='srgb'}


local Skybox = class('example/Skybox')

function Skybox:initialize( modelWorld )
    self.model = modelWorld:createModel('background')
    self.model:setMesh(skyboxMesh)
    self.model:setProgramFamily('skybox')
    self.model.shaderVariables:set('Texture', skyboxDiffuseTexture)
end

return Skybox
