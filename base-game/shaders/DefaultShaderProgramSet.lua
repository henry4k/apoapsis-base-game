local ShaderProgram    = require 'core/graphics/ShaderProgram'
local ShaderProgramSet = require 'core/graphics/ShaderProgramSet'

local defaultShaderProgram = ShaderProgram:load('base-game/shaders/Default.vert',
                                                'base-game/shaders/Default.frag')

local skyboxShaderProgram = ShaderProgram:load('base-game/shaders/Skybox.vert',
                                               'base-game/shaders/Skybox.frag')

local planetShaderProgram = ShaderProgram:load('base-game/shaders/normal-mapping.vert',
                                               'base-game/shaders/normal-mapping.frag',
                                               'base-game/shaders/Planet.vert',
                                               'base-game/shaders/Planet.frag')

local planetCloudsShaderProgram = ShaderProgram:load('base-game/shaders/normal-mapping.vert',
                                                     'base-game/shaders/normal-mapping.frag',
                                                     'base-game/shaders/Planet.vert',
                                                     'base-game/shaders/clouds.frag')

local DefaultShaderProgramSet = ShaderProgramSet(defaultShaderProgram)
DefaultShaderProgramSet:setFamily('skybox', skyboxShaderProgram)
DefaultShaderProgramSet:setFamily('planet', planetShaderProgram)
DefaultShaderProgramSet:setFamily('planet-clouds', planetCloudsShaderProgram)

return DefaultShaderProgramSet
