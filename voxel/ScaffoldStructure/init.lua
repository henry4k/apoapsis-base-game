local class          = require 'middleclass'
local Material       = require 'core/graphics/GraphicalMaterial'
local MeshBuffer     = require 'core/graphics/MeshBuffer'
local Texture        = require 'core/graphics/Texture'
local Voxel          = require 'core/voxel/Voxel'
local VoxelAccessor  = require 'core/voxel/VoxelAccessor'
local BlockVoxelMesh = require 'core/voxel/BlockVoxelMesh'
local SingleVoxelStructure = require 'core/voxel/SingleVoxelStructure'


local sideMeshBuffer   = MeshBuffer:load('base-game/voxel/ScaffoldStructure/Scene.json', 'Side')
local centerMeshBuffer = MeshBuffer:load('base-game/voxel/ScaffoldStructure/Scene.json', 'Center')
local plateMeshBuffer  = MeshBuffer:load('base-game/voxel/ScaffoldStructure/Scene.json', 'Plate')
local albedoTexture   = Texture:load('2d', 'base-game/voxel/ScaffoldStructure/Albedo.png')
local specularTexture = Texture:load('2d', 'base-game/voxel/ScaffoldStructure/Specular.png')
local normalTexture   = Texture:load('2d', 'base-game/voxel/ScaffoldStructure/Normal.png')


local ScaffoldStructure = class('base-game/voxel/ScaffoldStructure', SingleVoxelStructure)
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
                                      isTransparent = false }
    voxelMesh:addBitCondition(0, 10, ScaffoldStructure.id)
    voxelMesh:setMeshBuffer('center', centerMeshBuffer)
    voxelMesh:setMeshBuffer('+x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-x', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-y', sideMeshBuffer)
    voxelMesh:setMeshBuffer('+z', sideMeshBuffer)
    voxelMesh:setMeshBuffer('-z', sideMeshBuffer)
    generator:addVoxelMesh(voxelMesh)

    voxelMesh = BlockVoxelMesh{ material = material,
                                isTransparent = false }
    voxelMesh:addBitCondition(0, 10, ScaffoldStructure.id)
    voxelMesh:addBitCondition(10, 1, 1)
    voxelMesh:setMeshBuffer('+x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-x', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-y', plateMeshBuffer)
    voxelMesh:setMeshBuffer('+z', plateMeshBuffer)
    voxelMesh:setMeshBuffer('-z', plateMeshBuffer)
    generator:addVoxelMesh(voxelMesh)
end

function ScaffoldStructure:initialize( ... )
    SingleVoxelStructure.initialize(self, ...)
end

function ScaffoldStructure:create( voxelCreator, isPlated )
    self.isPlated = isPlated

    local voxel = Voxel()
    ScaffoldStructure.voxelAccessor:write(voxel, 'id', ScaffoldStructure.id)
    ScaffoldStructure.voxelAccessor:write(voxel, 'plated', self.isPlated)
    voxelCreator:writeVoxel(self.origin, voxel)
end

function ScaffoldStructure:read( voxelReader )
    local voxel = voxelReader:readVoxel(self.origin)
    self.isPlated = voxelAccessor:read(voxel, 'plated')
end

function ScaffoldStructure:write( voxelWriter )
    local voxel = Voxel()
    ScaffoldStructure.voxelAccessor:write(voxel, 'id', ScaffoldStructure.id)
    ScaffoldStructure.voxelAccessor:write(voxel, 'plated', self.isPlated)
    voxelWriter:write(self.origin, voxel)
end


return ScaffoldStructure
