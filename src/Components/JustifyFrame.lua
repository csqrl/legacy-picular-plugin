local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("JustifyFrame")

Component.defaultProps = {
    size = UDim2.fromScale(1, 1),
    position = UDim2.new(),
}

function Component:render()
    local childCount = Llama.Dictionary.count(self.props[Roact.Children])
    local childWidth = 1 / childCount

    local children = Llama.Dictionary.map(self.props[Roact.Children], function(element: RoactElement)
        local property = element.props["$justifyProp"]

        if type(property) ~= "string" then
            property = "size"
        end

        return e(element.component, Llama.Dictionary.merge(element.props, {
            [property] = UDim2.fromScale(childWidth, 1),
        }))
    end)

    return e("Frame", {
        BackgroundTransparency = 1,
        Size = self.props.size,
        Position = self.props.position,
    }, {
        layout = e("UIListLayout", {
            Padding = UDim.new(),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Center,
        }),

        content = Roact.createFragment(children),
    })
end

return Component
