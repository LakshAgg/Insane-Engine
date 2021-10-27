UI = Class{}

--[[
    Type:
        Button
        slider
]]

function UI:init(def)
    self.x = def.x or 0
    self.y = def.y or 0
    self.height = def.height
    self.width = def.width
    self.corners = def.corners
    self.mode = def.mode or 'fill'
    self.type = def.type
    
    self.color = {}
    self.color.r = def.color and def.color.r or 255/255
    self.color.g = def.color and def.color.g or 255/255
    self.color.b = def.color and def.color.b or 255/255
    self.color.a = def.color and def.color.a or 255/255
    self.toberendered = def.render
    if self.toberendered == nil then
        self.toberendered = true
    end

    UI.components = def.components or {}

    if self.type == 'slider' then
        self.handle = {}
        self.handle.mode = def.handlemode or self.mode
        self.handle.color = {}
        self.handle.color.r = def.handlecolor and def.handlecolor.r or 255/255
        self.handle.color.g = def.handlecolor and def.handlecolor.g or 255/255
        self.handle.color.b = def.handlecolor and def.handlecolor.b or 255/255
        self.handle.color.a = def.handlecolor and def.handlecolor.a or 255/255

        self.handle.width = def.handlewidth or 10
        self.handle.height = def.handleheight or self.height
        self.handle.x = (self.x)
        self.handle.y = (self.height / 2) + self.y - self.handle.height / 2
        self.handle.corners = def.handlecorners
        
        self.value = def.type == 'slider' and def.value or 0
        self.value = self.value == nil and 0 or self.value
        self.max_value = def.maxvalue or 0
    
        self.being_dragged = false
    elseif self.type == 'button' then
        self.wasPressed = false
    end

    self.on_pressed = def.onclick or function () end

    self.on_hover = def.onhover or function () end
end

function UI:update(dt)
    if self.type == 'slider' then
        local input = Engine.Input.MouseDown(1) 
        if self.being_dragged == false and input ~= false then
            if (input.x >= self.handle.x and input.x <= self.handle.x + self.handle.width) then
                if (input.y >= self.handle.y and input.y <= self.handle.y + self.handle.height) then
                    self.being_dragged = true
                end
            end
        elseif Engine.Input.MouseUp(1) then
            self.being_dragged = false
        end
        if self.being_dragged then
            input = {}
            input.x, input.y = Engine.Input.mouse()
            local o_x = (self.x)
            self.handle.x = math.max(o_x, math.min(input.x, o_x + self.width - self.handle.width))

            self.value = (self.handle.x - o_x) / (self.width - self.handle.width) * self.max_value
        end
    elseif self.type == 'button' then
        local input = Engine.Input.MouseDown(1) 
        if input ~= false then
            if (input.x >= self.x and input.x <= self.x + self.width) then
                if (input.y >= self.y and input.y <= self.y + self.height) then
                    self.wasPressed = true
                    self.on_pressed()
                    for i,v in pairs(self.components) do
                        if v.onclick ~= nil then
                            v.onclick()
                        end
                    end
                end
            else
                self.wasPressed = false
            end
        end
    end


    local input = {}
    input.x, input.y = Engine.Input.mouse()
    if (input.x >= self.x and input.x <= self.x + self.width) then
        if (input.y >= self.y and input.y <= self.y + self.height) then
            self.on_hover()
            for i,v in pairs(self.components) do
                if v.onhover ~= nil then
                    v.onhover()
                end
            end
        end
    end
end

function UI:render()
    if self.toberendered then
        love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
        love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, self.corners)
        if self.type == 'slider' then
            love.graphics.setColor(self.color.r, self.color.g, self.color.b, self.color.a)
            love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, self.corners)
            love.graphics.setColor(self.handle.color.r, self.handle.color.g, self.handle.color.b, self.handle.color.a)
            love.graphics.rectangle(self.handle.mode, self.handle.x, self.handle.y, self.handle.width, self.handle.height, self.handle.corners)
        end
    end
end