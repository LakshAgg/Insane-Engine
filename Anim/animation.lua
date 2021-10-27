Animation = Class{}

function Animation:init(def)
    self.frames = def.frames or {}

    self.activeFrameIndex = 1

    self.interval = def.interval or 0.1
    self.loop = def.loop or false
    self.isPlaying = false

    self.sx = def.scaleX or 1
    self.sy = def.scaleY or 1

    self.time = 0
end

function Animation:update(dt)
    self.time = self.time + dt

    if self.time >= self.interval then
        self.time = 0
        self.activeFrameIndex = (self.activeFrameIndex + 1) % #self.frames
    end
end

function Animation:render(texture, x, y)
    love.graphics.draw(texture, self.frames[self.activeFrameIndex], x, y, 0, self.sx, self.sy)
end