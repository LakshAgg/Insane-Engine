Animator = Class{}

function Animator:init(def)
    self.component = 'anim'
    self.animations = def.animations
    self.currentAnim = def.default
    self.color = NewColor()
    self.object = def.object
end

function Animator:update(dt)
    self.animations[self.currentAnim]:update(dt)
end

function Animator:render()
    SetColor(self.color)
    self.animations[self.currentAnim]:render(self.object.x, self.object.y)
end