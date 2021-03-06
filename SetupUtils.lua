local VoxelVolume       = require 'core/voxel/VoxelVolume'
local ChunkManager      = require 'core/voxel/ChunkManager'
local GlobalEventSource = require 'core/GlobalEventSource'
local ModelWorld        = require 'core/graphics/ModelWorld'
local PerspectiveCamera = require 'core/graphics/PerspectiveCamera'
local DefaultShaderProgramSet = require 'base-game/shaders/DefaultShaderProgramSet'


local SetupUtils = {}

function SetupUtils.setupVoxelVolume( size )
    local voxelVolume = VoxelVolume(size)
    GlobalEventSource:addEventTarget('shutdown', voxelVolume, function()
        voxelVolume:destroy()
    end)
    return voxelVolume
end

function SetupUtils.setupChunkManager( voxelVolume, modelWorld )
    local chunkManager = ChunkManager(voxelVolume, modelWorld)
    GlobalEventSource:addEventTarget('shutdown', chunkManager, function()
        chunkManager:destroy()
    end)
    return chunkManager
end

function SetupUtils.setupRenderTarget( renderTarget,
                                       shaderProgramSet,
                                       lightWorldClass )

    shaderProgramSet = shaderProgramSet or DefaultShaderProgramSet

    local foregroundModelWorld = ModelWorld()
    local worldModelWorld      = ModelWorld()
    local backgroundModelWorld = ModelWorld()

    local foregroundCamera = PerspectiveCamera(foregroundModelWorld)
    local worldCamera      = PerspectiveCamera(worldModelWorld)
    local backgroundCamera = PerspectiveCamera(backgroundModelWorld)

    local localLightWorld
    local backgroundLightWorld
    if lightWorldClass then
        localLightWorld = lightWorldClass()
        backgroundLightWorld = lightWorldClass()
    end

    local defaultRT = require 'core/graphics/DefaultRenderTarget'
    defaultRT:setCamera(0, 'foreground', foregroundCamera, localLightWorld)
    defaultRT:setCamera(2,      'world',      worldCamera, localLightWorld)
    defaultRT:setCamera(1, 'background', backgroundCamera, backgroundLightWorld)
    defaultRT:setShaderProgramSet(shaderProgramSet)
end

return SetupUtils
