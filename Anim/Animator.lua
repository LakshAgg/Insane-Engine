Animator = Class{}

function Animator:init(def)
    self.component = 'anim'
    self.animations = def.animations
    self.currentAnim = def.default
end

function Animator:update(dt)
    self.animations[self.currentAnim]:update(dt)
end