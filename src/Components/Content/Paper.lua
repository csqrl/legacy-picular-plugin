local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)

local e = Roact.createElement

local Component = Roact.Component:extend("Paper")

Component.defaultProps = {
    size = UDim2.fromScale(1, 1), -- UDim2
    anchor = nil, -- Vector2
    position = nil, -- UDim2
    order = nil, -- number
    colour = nil, -- Color3
    autoSize = nil, -- Enum.AutomaticSize
    transparency = 0, -- number
    corners = true, -- boolean
}

function Component:render()
    return e("Frame", {
        AutomaticSize = self.props.autoSize,
        BackgroundColor3 = self.props.colour,
        BackgroundTransparency = self.props.transparency,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        Size = self.props.size,
        Position = self.props.position,
        AnchorPoint = self.props.anchor,
        LayoutOrder = self.props.order,
    }, {
        borderRadius = self.props.corners and e(Styles.UICorner) or nil,
        content = Roact.createFragment(self.props[Roact.Children]),
    })
end

return Component
