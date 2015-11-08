local ShaderProgram    = require 'core/graphics/ShaderProgram'
local ShaderProgramSet = require 'core/graphics/ShaderProgramSet'

local defaultProgram = ShaderProgram:load('base-game/shaders/Default.vert',
                                                'base-game/shaders/Default.frag')

local skyboxProgram = ShaderProgram:load('base-game/shaders/Skybox.vert',
                                               'base-game/shaders/Skybox.frag')

local planetProgram = ShaderProgram:load('base-game/shaders/Lighting.vert',
                                               'base-game/shaders/Lighting.frag',
                                               'base-game/shaders/Planet.vert',
                                               'base-game/shaders/Planet.frag')

local planetAtmosphereProgram = ShaderProgram:load('base-game/shaders/Lighting.vert',
                                                   'base-game/shaders/Lighting.frag',
                                                   'base-game/shaders/PlanetAtmosphere.vert',
                                                   'base-game/shaders/PlanetAtmosphere.frag')

local DefaultShaderProgramSet = ShaderProgramSet(defaultProgram)
DefaultShaderProgramSet:setFamily('skybox', skyboxProgram)
DefaultShaderProgramSet:setFamily('planet', planetProgram)
DefaultShaderProgramSet:setFamily('planet-atmosphere', planetAtmosphereProgram)

return DefaultShaderProgramSet
