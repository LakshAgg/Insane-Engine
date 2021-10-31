GameObject = Class{}

function GameObject:init(def)
    self.components = def.components or {}

    -- collision related
    self.solid = def.solid or false
    self.on_collide = self.solid and def.onCollide or def.on_trigger
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
        end

        self.corners = def.corners or 0
        self.mode = def.mode or 'fill'
    elseif def.quad ~= nil then
        self.quad = def.quad
        self.width = def.width
        self.height = def.height
    else
        self.width = self.sprite and self.sprite:getWidth() or def.width
        self.height = self.sprite and self.sprite:getHeight() or def.height
    end
    self.color = {}
    self.color.r = def.color and def.color.r or 255/255
    self.color.g = def.color and def.color.g or 255/255
    self.color.b = def.color and def.color.b or 255/255
    self.color.a = def.color and def.color.a or 255/255
    self.toberendered = def.render
    if self.toberendered == nil then
        self.toberendered = true
    end
    
    -- component related
    for k,v in pairs(self.components) do
        if v.component == 'anim' then
            self.toberendered = false
            break
        end
    end
end

function GameObject:collides(object)
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
function GameObject:update(dt)
end

function GameObject:render()
    if self.toberendered then
        love.graphics.setColor(self.color.r,self.color.g,self.color.b,self.color.a)
        if type(self.sprite) == "string" then
            if self.sprite == 'rectangle' then
                love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, self.corners)
            elseif self.sprite == 'circle' then
                love.graphics.circle(self.mode, self.x, self.y, self.width, self.corners)
            end
        elseif self.quad then
            love.graphics.draw(self.sprite, self.quad, self.x, self.y, self.rotation, self.sx, self.sy)
        else
            love.graphics.draw(self.sprite, self.x, self.y, self.rotation, self.sx, self.sy)
        end
    end
end