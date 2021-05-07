local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)
local Util = require(Components.Util)
local Content = require(Components.Content)

local e = Roact.createElement

local Component = Roact.Component:extend("NavigationTabButton")

Component.defaultProps = {
    order = nil, -- number
    position = nil, -- UDim2
    size = UDim2.fromScale(1, 1), -- UDim2

    icon = nil, -- string
    label = nil, -- string

    active = false, -- string
    disabled = false, -- string
}

local function createBorder(
    edge: string, -- "top" | "left" | "bottom" | "right"
    colour: Color3
): RoactElement
    local anchor, position, size, zindex = nil, nil, nil, 10

    if edge == "left" then
        size = UDim2.new(0, 2, 1, 0)
    elseif edge == "right" then
        anchor = Vector2.new(1, 0)
        position = UDim2.fromScale(1, 0)
        size = UDim2.new(0, 2, 1, 0)
    elseif edge == "bottom" then
        anchor = Vector2.new(0, 1)
        position = UDim2.fromScale(0, 1)
        size = UDim2.new(1, 0, 0, 2)
    elseif edge == "top" then
        size = UDim2.new(1, 0, 0, 2)
        zindex = 1
    end

    return e("Frame", {
        AnchorPoint = anchor,
        BackgroundColor3 = colour,
        BorderSizePixel = 0,
        Position = position,
        Size = size,
        ZIndex = zindex,
    })
end

function Component:init()
    Util.ButtonBase.init(self)
end

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        local modifier, secondaryModifier = Util.ButtonBase.getModifier(self)

        return Util.ButtonBase.render(self, e("ImageButton", {
            AutoButtonColor = false,
            BackgroundColor3 = theme:GetColor("RibbonTab", secondaryModifier),
            BorderSizePixel = 0,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            ClipsDescendants = true,
            Image = "",
        }, {
            bordersContainer = e("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ClipsDescendants = true,
            }, {
                top = self.props.active and createBorder("top", theme:GetColor("LinkText", modifier)),
                right = self.props.active and createBorder("right", theme:GetColor("Border", modifier)),
                bottom = not self.props.active and createBorder("bottom", theme:GetColor("Border", modifier)),
                left = self.props.active and createBorder("left", theme:GetColor("Border", modifier)),
            }),

            contentContainer = e("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.new(1, styles.spacing * -2, 1, styles.spacing * -2),
                ZIndex = 10,
            }, {
                layout = e(Styles.UIListLayout, {
                    align = "centre",
                    direction = "x",
                }),

                icon = self.props.icon and e(Content.Icon, {
                    id = self.props.icon,
                    colour = theme:GetColor("ButtonText", modifier),
                }),

                label = self.props.label and e(Content.TextLabel, {
                    colour = theme:GetColor("ButtonText", modifier),
                    order = 10,
                    truncate = true,
                    wrapped = false,
                    autoSize = Enum.AutomaticSize.XY,
                    text = self.props.label,
                }),
            }),
        }))
    end)
end

return Component
