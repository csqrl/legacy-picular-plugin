local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("Section")

Component.defaultProps = {
    size = UDim2.fromScale(1, 0),
    position = nil,
    order = nil,
    gap = 2,
    indent = 0,
}

function Component:render()
    return StudioTheme.use(function(_, styles)
        return e("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
        }, {
            layout = e("UIListLayout", {
                Padding = UDim.new(0, styles.spacing * self.props.gap),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            padding = self.props.indent > 0 and e("UIPadding", {
                PaddingBottom = UDim.new(),
                PaddingLeft = UDim.new(0, styles.spacing * self.props.indent),
                PaddingRight = UDim.new(),
                PaddingTop = UDim.new(),
            }) or nil,

            content = Roact.createFragment(self.props[Roact.Children]),
        })
    end)
end

return Component
