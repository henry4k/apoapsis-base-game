local class          = require 'middleclass'
local Material       = require 'core/graphics/GraphicalMaterial'
local MeshBuffer     = require 'core/graphics/MeshBuffer'
local Texture        = require 'core/graphics/Texture'
local Voxel          = require 'core/voxel/Voxel'
local BlockVoxelMesh = require 'core/voxel/BlockVoxelMesh'


local sideMeshBuffer   = MeshBuffer:load(here('Scene.json'), 'Side')
local centerMeshBuffer = MeshBuffer:load(here('Scene.json'), 'Center')
local plateMeshBuffer  = MeshBuffer:load(here('Scene.json'), 'Plate')
local albedoTexture   = Texture:load{fileName=here('Albedo.png'),   colorSpace='srgb'}
local specularTexture = Texture:load{fileName=here('Specular.png'), colorSpace='srgb'}
local normalTexture   = Texture:load{fileName=here('Normal.png')}


local Scaffold = class(here(), Voxel)
Scaffold:addAttribute('plated', 1)
Scaffold:makeInstantiable()

function Scaffold.static:addVoxelMeshes( generator )
    local material = Material()
    material:setProgramFamily('simple')
    material.shaderVariables.AlbedoSampler   = albedoTexture
    material.shaderVariables.SpecularSampler = specularTexture
    material.shaderVariables.NormalSampler   = normalTexture

    local voxelMesh = BlockVoxelMesh{ material = material,
                                      voxelClass = self,
                                      isTransparent = false }
    voxelMesh:setMeshBuffer('center', centerMeshBuffer)
    voxelMesh:setMeshBuffer('+x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+z', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-z', sideMeshBuffer)
    generator:addVoxelMesh(voxelMesh)

    voxelMesh = BlockVoxelMesh{ material = material,
                                voxelClass = self,
                                isTransparent = false }
    voxelMesh:addAttributeCondition('plated', 1)
    voxelMesh:setMeshBuffer('+x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+z', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-z', plateMeshBuffer)
    generator:addVoxelMesh(voxelMesh)
end

function Scaffold:setPlating( status )
    self:setAttribute('plated', status)
end

return Scaffold
