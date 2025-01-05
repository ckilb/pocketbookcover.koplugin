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

    if not image then
        return
    end

    local width = Screen:getWidth()
    local height = Screen:getHeight()
    local rotation = Screen:getRotationMode()

    if rotation == 1 or rotation == 3 then
        local tmp = width

        width = height
        height = tmp
    end

    local imageScaled = RenderImage:scaleBlitBuffer(image, width, height)

    imageScaled:writeToFile("/mnt/ext1/system/logo/bookcover", "bmp", 100, false)
    imageScaled:writeToFile("/mnt/ext1/system/resources/Line/taskmgr_lock_background.bmp", "bmp", 100, false)
end

function PocketbookCover:onReaderReady(doc)
    self:update()
end

function PocketbookCover:onCloseDocument()
    self:update()
end

function PocketbookCover:onEndOfBook()
    self:update()
end

function PocketbookCover:onSuspend()
    self:update()
end

function PocketbookCover:onResume()
    self:update()
end

return PocketbookCover
