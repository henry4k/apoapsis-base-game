local class          = require 'middleclass'
local Material       = require 'core/graphics/GraphicalMaterial'
local MeshBuffer     = require 'core/graphics/MeshBuffer'
local Texture        = require 'core/graphics/Texture'
local Voxel          = require 'core/voxel/Voxel'
local VoxelAccessor  = require 'core/voxel/VoxelAccessor'
local BlockVoxelMesh = require 'core/voxel/BlockVoxelMesh'
local SingleVoxelStructure = require 'core/voxel/SingleVoxelStructure'


local sideMeshBuffer   = MeshBuffer:load(here('Scene.json'), 'Side')
local centerMeshBuffer = MeshBuffer:load(here('Scene.json'), 'Center')
local plateMeshBuffer  = MeshBuffer:load(here('Scene.json'), 'Plate')
local albedoTexture   = Texture:load{fileName=here('Albedo.png')}
local specularTexture = Texture:load{fileName=here('Specular.png')}
local normalTexture   = Texture:load{fileName=here('Normal.png')}


local ScaffoldStructure = class(here(), SingleVoxelStructure)
ScaffoldStructure:register()

local voxelAccessor = VoxelAccessor(SingleVoxelStructure.voxelAccessor)
voxelAccessor:addMask('plated', 1)
ScaffoldStructure.static.voxelAccessor = voxelAccessor

function ScaffoldStructure.static:setupMeshChunkGenerator( generator )
    local material = Material()
    material:setTexture(0, albedoTexture)
    material:setTexture(1, specularTexture)
    material:setTexture(2, normalTexture)
    material:setProgramFamily('simple')
    material:setUniform('AlbedoSampler',   0, 'int')
    material:setUniform('SpecularSampler', 1, 'int')
    material:setUniform('NormalSampler',   2, 'int')

    local voxelMesh = BlockVoxelMesh{ material = material,
                                      voxelAccessor = voxelAccessor,
                                      isTransparent = false }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:setMeshBuffer('center', centerMeshBuffer)
    voxelMesh:setMeshBuffer('+x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+z', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-z', sideMeshBuffer)
    generator:addVoxelMesh(voxelMesh)

    voxelMesh = BlockVoxelMesh{ material = material,
                                voxelAccessor = voxelAccessor,
                                isTransparent = false }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:addBitCondition('plated', 1)
    voxelMesh:setMeshBuffer('+x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+z', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-z', plateMeshBuffer)
    generator:addVoxelMesh(voxelMesh)
end

function ScaffoldStructure:create( isPlated )
    self.isPlated = isPlated
end

function ScaffoldStructure:read()
    local voxel = self:readVoxel(self.origin)
    self.isPlated = voxelAccessor:read(voxel, 'plated')
end

function ScaffoldStructure:write()
    local voxel = Voxel()
    voxelAccessor:write(voxel, 'id', ScaffoldStructure.id)
    voxelAccessor:write(voxel, 'plated', self.isPlated)
    self:writeVoxel(self.origin, voxel)
end


return ScaffoldStructure
