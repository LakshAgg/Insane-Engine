Util = {}

---Make a tilesheet of any image.
---@param sprite any
---@param width any
---@param height any
---@return table
function Util.newSpriteSheet(sprite, width, height)
    local sheet = {}
    local iWidth, iHeight = sprite:getWidth(), sprite:getHeight()

    local counter, rows, columns = 1, iHeight / height, iWidth / width

    for y = 0, rows - 1 do
        for x = 0, columns - 1 do
            sheet[counter] = love.graphics.newQuad(x * width, y * height, width, height, sprite:getDimensions())
            counter = counter + 1
        end
    end
    return sheet
end

---get values of table from s to e index
---@param table any
---@param s any
---@param e any
function Util.tableSlice(table, s, e)
    local newTable = {}
    local counter = 1

    for i = s or 1, e or #table do
        newTable[counter] = table[i]
        counter = counter + 1
    end
    return newTable
end


function NewColor(def)
    local color = {}
    if def ~= nil then 
        color.r = def.r or 1
        color.g = def.g or 1
        color.b = def.b or 1
        color.a = def.a or 1
    else
        color = {r = 1, g = 1, b = 1, a = 1}
    end
    return color
end

function SetColor(rgba)
    love.graphics.setColor(rgba.r, rgba.g, rgba.b, rgba.a)
end