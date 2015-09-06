local VoxelVolume       = require 'core/voxel/VoxelVolume'
local ChunkManager      = require 'core/voxel/ChunkManager'
local GlobalEventSource = require 'core/GlobalEventSource'
local ModelWorld        = require 'core/graphics/ModelWorld'
local PerspectiveCamera = require 'core/graphics/PerspectiveCamera'
local DefaultShaderProgramSet = require 'base-game/shaders/DefaultShaderProgramSet'


local SetupUtils = {}

function SetupUtils.setupVoxelVolume()
    local voxelVolume = VoxelVolume(size)
    GlobalEventSource:addEventTarget('shutdown', voxelVolume, function()
        voxelVolume:destroy()
    end)
    return voxelVolume
end

function SetupUtils.setupChunkManager()
    local chunkManager = ChunkManager(voxelVolume, worldModelWorld)
    GlobalEventSource:addEventTarget('shutdown', chunkManager, function()
        chunkManager:destroy()
    end)
    return chunkManager
end

function SetupUtils.setupRenderTarget( renderTarget )
    local foregroundModelWorld = ModelWorld()
    local worldModelWorld      = ModelWorld()
    local backgroundModelWorld = ModelWorld()

    local foregroundCamera = PerspectiveCamera(foregroundModelWorld)
    local worldCamera      = PerspectiveCamera(worldModelWorld)
    local backgroundCamera = PerspectiveCamera(backgroundModelWorld)

    local defaultRT = require 'core/graphics/DefaultRenderTarget'
    defaultRT:setCamera(0, 'foreground', foregroundCamera)
    defaultRT:setCamera(2,      'world',      worldCamera)
    defaultRT:setCamera(1, 'background', backgroundCamera)
    defaultRT:setShaderProgramSet(DefaultShaderProgramSet)
end

return SetupUtils
