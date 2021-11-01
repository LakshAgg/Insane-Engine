SceneManager = Class{}

function SceneManager:loadScene(scene, exitParameters, initParameters, enterParameters)
    if scene == nil then
        self.activeScene = Scenes.Main and Scenes.Main() or Scene()
        self.activeScene:enter()
        for i , v in pairs(self.activeScene.GameObjects) do
            for keyObj,g in pairs(v.components) do
                if g.enter then
                    g:enter(v)
                end
            end
        end
    else
        self.activeScene:exit(exitParameters)
        self.activeScene = Scenes[scene](initParameters)
        self.activeScene:enter(enterParameters)
        for i , v in pairs(self.activeScene.GameObjects) do
            for keyObj,g in pairs(v.components) do
                if g.enter then
                    g:enter(v)
                end
            end
        end
    end
end

function SceneManager:update(dt)
    self.activeScene:update(dt)
    for k, v in pairs(self.activeScene.GameObjects) do
        v:update(dt)
        for keyObj,g in pairs(v.components) do
            if g.update then
                g:update(dt, v)
            end
        end
        for key, c in pairs(self.activeScene.GameObjects) do
            if k ~= key then
                if v.collides then
                    v:collides(c)
                end
            end
        end
    end
end

function SceneManager:render()
    self.activeScene:render()
    for k, v in pairs(self.activeScene.GameObjects) do
        v:render()
    end
end