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
    UIManager:scheduleIn(1, function()
        self:update()
    end)
end

function PocketbookCover:onPageUpdate()
    if not self.view.state then
        return nil
    end

    if not self.view.state.page then
        return nil
    end

    local page = self.document:getPageNumberInFlow(self.view.state.page)

    if page == 1 then
        self:update()
    end
end

return PocketbookCover
