local class          = require 'middleclass'
local Vec            = require 'core/Vector'
local Mat4           = require 'core/Matrix4'
local Material       = require 'core/graphics/GraphicalMaterial'
local MeshBuffer     = require 'core/graphics/MeshBuffer'
local Texture        = require 'core/graphics/Texture'
local Voxel          = require 'core/voxel/Voxel'
local VoxelAccessor  = require 'core/voxel/VoxelAccessor'
local BlockVoxelMesh = require 'core/voxel/BlockVoxelMesh'
local AabbStructure  = require 'core/voxel/AabbStructure'


local sphereMeshBuffer      = MeshBuffer:load(here('Scene.json'), 'Sphere')
local centerMeshBuffer      = MeshBuffer:load(here('Scene.json'), 'Center')
local endMeshBuffer         = MeshBuffer:load(here('Scene.json'), 'End')
local pipeOpeningMeshBuffer = MeshBuffer:load(here('Scene.json'), 'PipeOpening')
local albedoTexture   = Texture:load{fileName=here('Albedo.png')}
local specularTexture = Texture:load{fileName=here('Specular.png')}
local normalTexture   = Texture:load{fileName=here('Normal.png')}


local halfPi = math.pi / 2.0
local zToX = Mat4():rotate(halfPi, Vec(0,1,0))
local zToY = Mat4():rotate(halfPi, Vec(1,0,0))


local FluidTank = class(here(), AabbStructure)
FluidTank:register()

local voxelAccessor = VoxelAccessor(AabbStructure.voxelAccessor)
voxelAccessor:addMask('PartType', 2) -- sphere, end, center
voxelAccessor:addMask('PartDirection', 2) -- x, y, z
FluidTank.static.voxelAccessor = voxelAccessor

function FluidTank.static:setupMeshChunkGenerator( generator )
    local material = Material()
    material:setTexture(0, albedoTexture)
    material:setTexture(1, specularTexture)
    material:setTexture(2, normalTexture)
    material:setProgramFamily('simple')
    material:setUniform('AlbedoSampler',   0, 'int')
    material:setUniform('SpecularSampler', 1, 'int')
    material:setUniform('NormalSampler',   2, 'int')

    -- sphere
    local voxelMesh = BlockVoxelMesh{ material = material,
                                      voxelAccessor = voxelAccessor,
                                      isTransparent = true }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:addBitCondition('PartType', 0)
    --voxelMesh:addBitCondition('PartDirection', 0)
    voxelMesh:setMeshBuffer('center', sphereMeshBuffer)
    generator:addVoxelMesh(voxelMesh)

    -- center (in x direction)
    voxelMesh = BlockVoxelMesh{ material = material,
                                voxelAccessor = voxelAccessor,
                                isTransparent = true }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:addBitCondition('PartType', 1)
    voxelMesh:addBitCondition('PartDirection', 0)
    voxelMesh:setMeshBuffer('center', centerMeshBuffer, zToX)
    generator:addVoxelMesh(voxelMesh)


    -- center (in y direction)
    voxelMesh = BlockVoxelMesh{ material = material,
                                voxelAccessor = voxelAccessor,
                                isTransparent = true }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:addBitCondition('PartType', 1)
    voxelMesh:addBitCondition('PartDirection', 1)
    voxelMesh:setMeshBuffer('center', centerMeshBuffer, zToY)
    generator:addVoxelMesh(voxelMesh)


    -- center (in z direction)
    voxelMesh = BlockVoxelMesh{ material = material,
                                voxelAccessor = voxelAccessor,
                                isTransparent = true }
    voxelMesh:addBitCondition('id', self.id)
    voxelMesh:addBitCondition('PartType', 1)
    voxelMesh:addBitCondition('PartDirection', 2)
    voxelMesh:setMeshBuffer('center', centerMeshBuffer)
    generator:addVoxelMesh(voxelMesh)
end

function FluidTank:create( ... )
    AabbStructure.create(self, ...)
end

function FluidTank:read()
    AabbStructure.read(self)
    local voxel = self:readVoxel(self.origin)
    self.isPlated = voxelAccessor:read(voxel, 'plated')
end

function FluidTank:write()
    AabbStructure.write(self)
    local voxel = Voxel()
    voxelAccessor:write(voxel, 'id', self.id)
    voxelAccessor:write(voxel, 'plated', self.isPlated)
    self:writeVoxel(self.origin, voxel)
end


return FluidTank
