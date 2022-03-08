GameObject = Class{}

function GameObject:init(def)
    self.components = def.components or {}

    -- collision related
    self.solid = def.solid or false
    self.on_collide = self.solid and def.onCollide or def.onTrigger
    self.on_collide = self.on_collide or function () end
    
    -- transform related
    self.x = def.x or 0
    self.y = def.y or 0
    self.rotation = def.rotation or 0
    self.sx = def.scaleX or 1
    self.sy = def.scaleY or 1
    
    -- rendering related
    self.sprite = def.sprite
    if type(self.sprite) == "string" then
        self.width = def.width
        if self.sprite == 'rectangle' then
            self.height = def.height
        elseif self.sprite == 'circle' then
            self.height = self.width
        elseif self.sprite == 'ellipse' then
            self.height = def.height or self.width
        end

        self.corners = def.corners or 0
        self.mode = def.mode or 'fill'
    elseif def.quad ~= nil then
        self.quad = def.quad
        local qx, qy, qw, qh = self.quad:getViewport()
        self.width = qw
        self.height = qh
    else
        self.width = self.sprite and self.sprite:getWidth() or def.width
        self.height = self.sprite and self.sprite:getHeight() or def.height
    end
    self.color = NewColor(def.color)

    self.toberendered = def.render
    if self.toberendered == nil then
        self.toberendered = true
    end
    
    -- component related
    for k,v in pairs(self.components) do
        if v.component == 'anim' then
            self.toberendered = false
            v.color = self.color
            if v.object == nil then
                v.object = self
            end
            break
        end
    end
end

function GameObject:collides(object)
    if object.solid then
        if self.x < object.x + object.width and self.x + self.width > object.x then
            if self.y < object.y + object.height and self.y + self.height > object.y then
                self.on_collide(object)
                for k,v in pairs(self.components) do
                    if v.onCollide then
                        v:onCollide(self, object)
                    end
                end
            end
        end
    end
end
function GameObject:update(dt)
end

function GameObject:render()
    if self.toberendered then
        SetColor(self.color)
        if type(self.sprite) == "string" then
            if self.sprite == 'rectangle' then
                love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, self.corners)
            elseif self.sprite == 'circle' then
                love.graphics.circle(self.mode, self.x + self.width / 2, self.y + self.width / 2, self.width / 2,  self.corners)
            elseif self.sprite == 'ellipse' then
                love.graphics.ellipse(self.mode, self.x + self.width / 2, self.y + self.height / 2, self.width / 2, self.height / 2)
            end
        elseif self.quad then
            love.graphics.draw(self.sprite, self.quad, self.x, self.y, self.rotation, self.sx, self.sy)
        else
            love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.sx, self.sy)
        end
    end
end