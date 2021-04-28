local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Icons = require(Root.Data.Icons)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("Icon")

Component.defaultProps = {
    id = nil,
    colour = Color3.new(1, 1, 1),

    size = nil,
    position = nil,

    order = nil,
    transparency = nil,
}

function Component:init()
    self.icon = Icons[self.props.id]
end

function Component:didUpdate(prevProps)
    if prevProps.id ~= self.props.id then
        self.icon = Icons[self.props.id]
    end
end

function Component:render()
    return e("ImageLabel", {
        BackgroundTransparency = 1,
        LayoutOrder = self.props.order,
        Size = self.props.size or UDim2.fromOffset(self.icon.W, self.icon.H),
        Image = self.icon.ImageId,
        ImageColor3 = self.props.colour,
        ImageRectOffset = Vector2.new(self.icon.X, self.icon.Y),
        ImageRectSize = Vector2.new(self.icon.W, self.icon.H),
        ImageTransparency = self.props.transparency,
    })
end

return Component
