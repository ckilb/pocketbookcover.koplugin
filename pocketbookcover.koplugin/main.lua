local WidgetContainer = require("ui/widget/container/widgetcontainer")
local _ = require("gettext")
local UIManager = require("ui/uimanager")
local FileManagerBookInfo = require("apps/filemanager/filemanagerbookinfo")
local Screen = require("device").screen
local RenderImage = require("ui/renderimage")

local PocketbookCover = WidgetContainer:extend{
    name = "pocketbookcover",
    is_doc_only = false,
}

function PocketbookCover:update(title, page)
    local image, _ = FileManagerBookInfo:getCoverImage(self.ui.document);

    local width = Screen:getWidth()
    local height = Screen:getHeight()
    local rotation = Screen:getRotationMode()

    if rotation == 1 or rotation == 3 then
        local tmp = width

        width = height
        height = tmp
    end

    image = RenderImage:scaleBlitBuffer(image, width, height)
    image:writeToFile("/mnt/ext1/system/logo/bookcover", "bmp", 100, false)
end

function PocketbookCover:onReaderReady(doc)
    UIManager:scheduleIn(1, function()
        self:update()
    end)
end

return PocketbookCover
