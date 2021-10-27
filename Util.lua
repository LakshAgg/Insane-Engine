Util = {}

---Make a tilesheet of any image.
---@param sprite any
---@param width any
---@param height any
---@return table
function Util.NewSpriteSheet(sprite, width, height)
    local sheet = {}
    local iWidth, iHeight = sprite:getWidth(), sprite:getHeight()

    local counter, rows, columns = 0, iHeight / height, iWidth / width

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
function Util.table_slice(table, s, e)
    local newTable = {}
    local counter = 0

    for i = s or 1, e or #table do
        newTable[counter] = table[i]
        counter = counter + 1
    end
    return newTable
end 