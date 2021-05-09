local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)
local Content = require(Components.Content)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("SmartFillBanner")

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        return e(Content.Paper, {
            colour = theme:GetColor("Titlebar"),
            size = UDim2.fromScale(1, 0),
            autoSize = Enum.AutomaticSize.Y,
        }, {
            padding = e(Styles.UIPadding),
            layout = e(Styles.UIListLayout, {
                alignX = "end",
                spacing = styles.spacing * .5,
            }),

            titleRow = e(Content.Paper, {
                size = UDim2.fromScale(1, 0),
                autoSize = Enum.AutomaticSize.Y,
                transparency = 1,
                corners = false,
            }, {
                layout = e(Styles.UIListLayout, {
                    direction = "x",
                    alignX = "end",
                }),

                fillIcon = e(Content.Icon, {
                    id = "FillBucket",
                    colour = "TitlebarText",
                }),

                titleText = e(Content.TextLabel, {
                    text = "SmartFill Action",
                    autoSize = Enum.AutomaticSize.XY,
                    colour = "TitlebarText",
                    wrapped = true,
                    fontWeight = "bold",
                    alignX = Enum.TextXAlignment.Right,
                }),
            }),

            actionText = e(Content.TextLabel, {
                text = "No Selection",
                autoSize = Enum.AutomaticSize.XY,
                colour = "TitlebarText",
                wrapped = true,
                font = "mono",
                fontSizeOffset = 2,
                alignX = Enum.TextXAlignment.Right,
                richText = true,
            }),
        })
    end)
end

return Component
