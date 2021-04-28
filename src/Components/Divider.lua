local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("Divider")

Component.defaultProps = {
    width = 1,
    modifier = nil,
    position = nil,
    order = nil,
}

function Component:render()
    return StudioTheme.use(function(theme: StudioTheme)
        return e("Frame", {
            BackgroundColor3 = theme:GetColor("Border", self.props.modifier),
            BorderSizePixel = 0,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = UDim2.new(1, 0, 0, self.props.width),
        })
    end)
end

return Component
