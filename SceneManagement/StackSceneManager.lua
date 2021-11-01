StackSceneManager = Class{}

function StackSceneManager:push(scene, initParameters, enterParameters)
    if (scene == nil) then
        self.stack = {}
        self.index = 1
        self.stack[1] = Scenes['Main'] and Scenes['Main']() or Scene()

        self.stack[1]:enter()
        for i , v in pairs(self.stack[1].GameObjects) do
            for keyObj,g in pairs(v.components) do
                if g.enter then
                    g:enter(v)
                end
            end
        end
    else
        self.index = self.index + 1
        self.stack[self.index] = Scenes[scene](initParameters)
        self.stack[self.index]:enter(enterParameters)
        for i , v in pairs(self.stack[self.index].GameObjects) do
            for keyObj,g in pairs(v.components) do
                if g.enter then
                    g:enter(v)
                end
            end
        end
    end
end

function StackSceneManager:pop(exitParameters)
    self.stack[self.index]:exit(exitParameters)
    table.remove(self.stack, self.index)
    self.index = self.index - 1
end

function StackSceneManager:update(dt)
    self.stack[self.index]:update(dt)
    for k, v in pairs(self.stack[self.index].GameObjects) do
        v:update(dt)
        for keyObj,g in pairs(v.components) do
            if g:update() then
                g:update(dt, v)
            end
        end
        for key, c in pairs(self.stack[self.index].GameObjects) do
            if k ~= key then
                if v.collides then
                    v:collides(c)
                end
            end
        end
    end
end

function StackSceneManager:render()
    for i = 1, #self.stack do
        self.stack[i]:render()
        for k, v in pairs(self.stack[i].GameObjects) do
            v:render()
        end
    end
end