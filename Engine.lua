require('Engine.Dependencies')


Engine = {}
Engine.Input = {}
Engine.Input.KeysPressed = {}

Engine.Input.MouseKeyPressed = {}
Engine.Input.MouseKeyReleased = {}

function love.load()
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, PushSetup)
    love.window.setTitle(GameTitle)
    SceneManager.loadScene()
end

function love.update(dt)
    SceneManager.update(dt)
    Engine.Input.KeysPressed = {}

    Engine.Input.MouseKeyPressed = {}
    Engine.Input.MouseKeyReleased = {}
end

function love.draw()
    push:start()
    SceneManager.render()
    push:finish()
end

function love.keypressed(k)
    if k == 'escape' then
        love.event.quit()
    end
    Engine.Input.KeysPressed[k] = true
end

function Engine.Input.KeyPressed(key)
    return Engine.Input.KeysPressed[key] or false
end
function Engine.Input.MouseDown(key)
    return Engine.Input.MouseKeyPressed[key] or false
end
function Engine.Input.MouseUp(key)
    return Engine.Input.MouseKeyReleased[key] or false
end

function love.mousepressed(x, y, key)
    x, y = push:toGame(x, y)
    Engine.Input.MouseKeyPressed[key] = {x = x, y = y}
end

function love.mousereleased(x, y, key)
    x, y = push:toGame(x, y)
    Engine.Input.MouseKeyReleased[key] = {x = x, y = y}
end

function Engine.Input.mouse()
    local input = {}
    input.x, input.y = love.mouse.getPosition()
    return push:toGame(input.x, input.y)
end