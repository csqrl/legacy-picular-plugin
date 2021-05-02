local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local PluginUpdater = require(Root.Services.PluginUpdater)

local StudioTheme = require(Components.StudioTheme)
local UIPadding = require(Components.UIPadding)
local UIListLayout = require(Components.UIListLayout)
local TextLabel = require(Components.TextLabel)

local e = Roact.createElement
local fmt = string.format

local Component: RoactComponent = Roact.Component:extend("UpdateBanner")

Component.defaultProps = {
    show = false,
    semver = "1.0.0",
}

function Component:init()
    self.onClick = function()
        coroutine.wrap(PluginUpdater.DisplayPluginManagementHelp)()
    end
end

function Component:render()
    return StudioTheme.use(function(theme: StudioTheme)
        return e("TextButton", {
            AutomaticSize = Enum.AutomaticSize.Y,
            AutoButtonColor = false,
            BackgroundColor3 = theme:GetColor("WarningText"),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 0),
            Text = "",

            [Roact.Event.Activated] = self.onClick,
        }, {
            padding = e(UIPadding),
            listLayout = e(UIListLayout, {
                offset = .5,
            }),

            title = e(TextLabel, {
                label = fmt("Update to v%s", self.props.semver),
                colour = theme:GetColor("DialogMainButtonText"),
                fontWeight = "bold",
            }),

            subtext = e(TextLabel, {
                label = "A plugin update is available. Click here to learn how to update.",
                colour = theme:GetColor("DialogMainButtonText"),
                order = 10,
            }),
        })
    end)
end

return Component
