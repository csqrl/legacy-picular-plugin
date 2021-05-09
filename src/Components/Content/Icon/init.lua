local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Assets = require(script.Assets)

local Styles = require(Components.Styles)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("Icon")

Component.defaultProps = {
    id = nil, -- string
    colour = "MainText", -- Color3 | Enum.StudioStyleGuideColor
    modifier = nil, -- Enum.StudioStyleGuideModifier
    order = nil, -- number
    size = nil, -- UDim2
    position = nil, -- UDim2
    transparency = nil, -- number
    anchor = nil, -- Vector2
}

function Component:init()
    self.icon = Assets[self.props.id]
end

function Component:didUpdate(prevProps)
    if prevProps.id ~= self.props.id then
        self.icon = Assets[self.props.id]
    end
end

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        local iconColour = self.props.colour

        if typeof(iconColour) ~= "Color3" then
            iconColour = theme:GetColor(iconColour, self.props.modifier)
        end

        return e("ImageLabel", {
            AnchorPoint = self.props.anchor,
            BackgroundTransparency = 1,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size or UDim2.fromOffset(
                self.icon.W or styles.fontSize,
                self.icon.H or styles.fontSize
            ),
            Image = self.icon.AssetId,
            ImageColor3 = iconColour,
            ImageRectOffset = Vector2.new(self.icon.X or 0, self.icon.Y or 0),
            ImageRectSize = Vector2.new(self.icon.W or 0, self.icon.H or 0),
            ImageTransparency = self.props.transparency,
        })
    end)
end

return Component
