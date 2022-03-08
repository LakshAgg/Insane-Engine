Animation = Class{}

function Animation:init(def)
    self.frames = def.frames or {}
    self.totalframes = #self.frames
    self.activeFrameIndex = 1

    self.interval = def.interval or 0.1
    self.loop = def.loop or false
    self.isPlaying = false

    self.sx = def.scaleX or 1
    self.sy = def.scaleY or 1
    self.texture = def.texture
    self.time = 0
end

function Animation:update(dt)
    self.time = self.time + dt

    if self.time >= self.interval then
        self.time = 0
        if self.activeFrameIndex < self.totalframes or self.loop then
            self.activeFrameIndex = self.activeFrameIndex + 1
        end
        if self.activeFrameIndex > self.totalframes and self.loop then
           self.activeFrameIndex = 1 
        end
    end
end

function Animation:render(x, y)
    love.graphics.draw(self.texture, self.frames[self.activeFrameIndex], x, y, 0, self.sx, self.sy)
end