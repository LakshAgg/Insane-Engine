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
    self.interactable = def.interactable
    if self.interactable == nil then
        self.interactable = true
    end
    if self.toberendered == nil then
        self.toberendered = true
    end

    UI.components = def.components or {}

    if self.type == 'slider' then
        self.handle = {}
        self.handle.mode = def.handleMode or self.mode
        self.handle.color = NewColor(def.handleColor)

        self.handle.width = def.handleWidth or 10
        self.handle.height = def.handleHeight or self.height
        self.handle.y = (self.height / 2) + self.y - self.handle.height / 2
        self.handle.corners = def.handleCorners
        
        self.value = def.type == 'slider' and def.value or 0
        self.value = self.value == nil and 0 or self.value
        self.max_value = def.maxValue or 0
        self.handle.x = (self.x) + self.width * self.value / self.max_value

        self.handle.toberendered = def.renderHandle
        if self.handle.toberendered == nil then
            self.handle.toberendered = true
        end

        self.beingDragged = false

        self.bg_color = NewColor(def.backgroundColor)
    elseif self.type == 'button' then
        self.wasPressed = false
        self.text = def.text
        self.textColor = NewColor(def.textColor)
    end

    self.on_pressed = def.onClick or function () end

    self.on_hover = def.onHover or function () end

    -- component related
    for k,v in pairs(self.components) do
        if v.component == 'anim' then
            self.toberendered = false
            v.color = self.color
            break
        end
    end
end

function UI:update(dt)
    self.wasPressed = false

    if self.type == 'slider' then
        local input = Engine.Input.MouseDown(1) 
        if self.beingDragged == false and input ~= false and self.interactable then
            if (input.x >= self.handle.x and input.x <= self.handle.x + self.handle.width) then
                if (input.y >= self.handle.y and input.y <= self.handle.y + self.handle.height) then
                    self.beingDragged = true
                end
            end
        elseif Engine.Input.MouseUp(1) then
            self.beingDragged = false
        end
        if self.beingDragged then
            input = {}
            input.x, input.y = Engine.Input.mouse()
            local o_x = (self.x)
            self.handle.x = math.max(o_x, math.min(input.x, o_x + self.width - self.handle.width))

            self.value = (self.handle.x - o_x) / (self.width - self.handle.width) * self.max_value
        end
    elseif self.type == 'button' then
        local input = Engine.Input.MouseDown(1) 
        if input ~= false and self.interactable then
            if (input.x >= self.x and input.x <= self.x + self.width) then
                if (input.y >= self.y and input.y <= self.y + self.height) then
                    self.wasPressed = true
                    self.on_pressed()
                    for i,v in pairs(self.components) do
                        if v.onClick ~= nil then
                            v.onClick()
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
                if v.onHover ~= nil then
                    v.onHover()
                end
            end
        end
    end

    -- self.wasPressed = false;
end

function UI:render()
    if self.toberendered then
        SetColor(self.color)
        love.graphics.rectangle(self.mode, self.x, self.y, self.width, self.height, self.corners)
        if self.type == 'slider' then
            if self.value > 0 then
                SetColor(self.bg_color)
                love.graphics.rectangle(self.mode, self.x, self.y, self.width * self.value / self.max_value, self.height, self.corners)
            end
            if self.handle.toberendered then
                SetColor(self.handle.color)
                love.graphics.rectangle(self.handle.mode, self.handle.x, self.handle.y, self.handle.width, self.handle.height, self.handle.corners)
            end
        elseif (self.text ~= nil) then
            SetColor(self.textColor)
            love.graphics.printf(self.text, self.x, self.y, self.width, "center")
        end
    end
end