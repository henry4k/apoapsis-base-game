local class          = require 'middleclass'
local Vec            = require 'core/Vector'
local Mat4           = require 'core/Matrix4'
local Generators     = require 'core/Generators'
local Material       = require 'core/graphics/GraphicalMaterial'
local MeshBuffer     = require 'core/graphics/MeshBuffer'
local Texture        = require 'core/graphics/Texture'
local Voxel          = require 'core/voxel/Voxel'
local BlockVoxelMesh = require 'core/voxel/BlockVoxelMesh'


local sphereMeshBuffer      = MeshBuffer:load(here('Scene.json'), 'Sphere')
local centerMeshBuffer      = MeshBuffer:load(here('Scene.json'), 'Center')
local endMeshBuffer         = MeshBuffer:load(here('Scene.json'), 'End')
local pipeOpeningMeshBuffer = MeshBuffer:load(here('Scene.json'), 'PipeOpening')
local albedoTexture   = Texture:load{fileName=here('Albedo.png'), colorSpace='srgb'}
local specularTexture = Texture:load{fileName=here('Specular.png'), colorSpace='srgb'}
local normalTexture   = Texture:load{fileName=here('Normal.png')}


local halfPi = math.pi / 2.0
local zToX = Mat4():rotate(halfPi, Vec(0,1,0))
local zToY = Mat4():rotate(halfPi, Vec(1,0,0))


local FluidTank = class(here(), Voxel)
FluidTank:addAttribute('PartType', 2) -- sphere, end, center
FluidTank:addAttribute('PartDirection', 2) -- x, y, z
FluidTank:makeInstantiable()

local partTypes =
{
    sphere  = { id = 0, meshBuffer = sphereMeshBuffer },
    ['end'] = { id = 1, meshBuffer = endMeshBuffer    },
    center  = { id = 2, meshBuffer = centerMeshBuffer }
}
local idToPartTypeName =
{
    [0] = 'sphere',
    [1] = 'end',
    [2] = 'center'
}

local directions =
{
    x = { id = 0, normal = Vec(1,0,0), transformation = zToX },
    y = { id = 1, normal = Vec(0,1,0), transformation = zToY },
    z = { id = 2, normal = Vec(0,0,1), transformation = nil  }
}
local idToDirectionName =
{
    [0] = 'x',
    [1] = 'y',
    [2] = 'z'
}

function FluidTank.static:addVoxelMeshes( generator )
    local material = Material()
    material:setProgramFamily('simple')
    material.shaderVariables.AlbedoSampler   = albedoTexture
    material.shaderVariables.SpecularSampler = specularTexture
    material.shaderVariables.NormalSampler   = normalTexture

    for _, typeName, directionName in
        Generators.permutate(table.listKeys(partTypes),
                             table.listKeys(directions)) do
        local partType = partTypes[typeName]
        local direction = directions[directionName]
        local voxelMesh = BlockVoxelMesh{ material = material,
                                          voxelClass = self,
                                          isTransparent = true }
        voxelMesh:addAttributeCondition('PartType', partType.id)
        voxelMesh:addAttributeCondition('PartDirection', direction.id)
        voxelMesh:setMeshBuffer('center',
                                partType.meshBuffer,
                                direction.transformation)
        generator:addVoxelMesh(voxelMesh)
    end
end

--[[
function FluidTank:create( partType, direction, length )
    assert(length >= 1 and math.isInteger(length))

    self:setPartType(partType)
    self:setDirection(direction)

    local size = Vec(1,1,1) + directions[self.direction].normal*(length-1)
    AabbStructure.create(self, size)
end

function FluidTank:setPartType( name )
    assert(partTypes[name], 'No such part type.')
    self.partType = name
end

function FluidTank:setDirection( name )
    assert(directions[name], 'No such direction.')
    self.direction = name
end

function FluidTank:read()
    AabbStructure.read(self)
    local voxel = self:readVoxel(self.origin)

    local partTypeId = voxelAccessor:read(voxel, 'PartType')
    self:setPartType(idToPartTypeName[partTypeId])

    local directionId = voxelAccessor:read(voxel, 'PartDirection')
    self:setDirection(idToDirectionName[directionId])
end

function FluidTank:write()
    AabbStructure.write(self)

    local size = self.size

    for offsetZ = 0, size[3]-1 do
    for offsetY = 0, size[2]-1 do
    for offsetX = 0, size[1]-1 do
        local voxel = Voxel()
        voxelAccessor:write(voxel, 'id', FluidTank.id)

        local partTypeId = partTypes[self.partType].id
        voxelAccessor:write(voxel, 'PartType', partTypeId)

        local directionId = directions[self.direction].id
        voxelAccessor:write(voxel, 'PartDirection', directionId)

        local offset = Vec(offsetX, offsetY, offsetZ)
        self:writeVoxel(self.origin + offset, voxel)
    end
    end
    end
end
]]


return FluidTank
