
-- window setup
VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

GameTitle = 'My Game'

PushSetup = {
    fullscreen = false,
    vsync = true,
    resizable = true,
    canvas = false
}

-- set filter (optional)
love.graphics.setDefaultFilter('nearest', 'nearest')

-- Scenes
Scenes = {}

-- type of scene management system can be "normal" || "stack"
SceneManagerType = "normal"