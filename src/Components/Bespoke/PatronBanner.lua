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
            colour = theme:GetColor("WarningText"),
            size = UDim2.fromScale(1, 0),
            autoSize = Enum.AutomaticSize.Y,
            clickable = true,
        }, {
            padding = e(Styles.UIPadding, {
                right = styles.spacing * 3,
                left = styles.spacing,
            }),

            layout = e(Styles.UIListLayout, {
                direction = "x",
                align = "start",
            }),

            robuxIcon = e(Content.Icon, {
                id = "Robux",
                colour = Color3.new(1, 1, 1),
            }),

            textContainer = e(Content.Paper, {
                transparency = 1,
                corners = false,
                autoSize = Enum.AutomaticSize.XY,
                order = 10,
            }, {
                layout = e(Styles.UIListLayout, {
                    align = "start",
                    direction = "y",
                    spacing = styles.spacing * .5,
                }),

                titleText = e(Content.TextLabel, {
                    text = "Support this plugin",
                    colour = Color3.new(1, 1, 1),
                    autoSize = Enum.AutomaticSize.XY,
                    wrapped = true,
                    fontWeight = "bold",
                }),

                captionText = e(Content.TextLabel, {
                    text = "Click here to show your support for this plugin with a small non-obligatory donation.",
                    colour = Color3.new(1, 1, 1),
                    autoSize = Enum.AutomaticSize.XY,
                    wrapped = true,
                }),
            })
        })
    end)
end

return Component
