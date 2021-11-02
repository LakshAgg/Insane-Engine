Animator = Class{}

function Animator:init(def)
    self.component = 'anim'
    self.animations = def.animations
    self.currentAnim = def.default
    self.color = NewColor()
end

function Animator:update(dt)
    self.animations[self.currentAnim]:update(dt)
end

function Animator:render()
    SetColor(self.color)
    self.animations[self.currentAnim]:render()
end