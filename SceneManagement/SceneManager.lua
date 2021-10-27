SceneManager = Class{}

function SceneManager.loadScene(scene)
    if scene == nil then
        SceneManager.activeScene = Scenes.Main and Scenes.Main() or Scene()
        SceneManager.activeScene:enter()
        for i , v in pairs(SceneManager.activeScene.GameObjects) do
            for keyObj,g in pairs(v.components) do
                g:enter(v)
            end
        end
    else
        SceneManager.activeScene:exit()
        SceneManager.activeScene = Scenes[scene]()
        SceneManager.activeScene:enter()
    end
end

function SceneManager.update(dt)
    SceneManager.activeScene:update(dt)
    for k, v in pairs(SceneManager.activeScene.GameObjects) do
        v:update(dt)
        for keyObj,g in pairs(v.components) do
            g:update(dt, v)
        end
        for key, c in pairs(SceneManager.activeScene.GameObjects) do
            if k ~= key then
                v:collides(c)
            end
        end
    end
end

function SceneManager.render()
    SceneManager.activeScene:render()
    for k, v in pairs(SceneManager.activeScene.GameObjects) do
        v:render()
    end
end