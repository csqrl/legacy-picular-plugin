local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local UIListLayout: RoactComponent = require(script.Parent.UIListLayout)

local e = Roact.createElement
local max = math.max

local Component = Roact.Component:extend("JustifyFrame")

Component.defaultProps = {
    autoSize = nil, -- Enum.AutomaticSize
    size = UDim2.fromScale(1, 1), -- UDim2
    position = nil, -- UDim2
    direction = "x", -- ("x" | "h" | "horizontal") | ("y" | "v" | "vertical")
    order = nil, -- number
    spacing = 0, -- number
}

function Component:render()
    local childCount = max(self.props[Roact.Children] and Llama.Dictionary.count(self.props[Roact.Children]) or 1, 1)
    local childSize = UDim2.fromScale(1 / childCount, 1)

    if table.find({ "y", "v", "vertical" }, self.props.direction) ~= nil then
        childSize = UDim2.fromScale(1, 1 / childCount)
    end

    local children = Llama.Dictionary.map(self.props[Roact.Children], function(element: RoactElement)
        local elProp = element.props["$justify"]

        if type(elProp) ~= "string" then
            elProp = "size"
        end

        return e(element.component, Llama.Dictionary.merge(element.props, {
            [elProp] = childSize,
        }))
    end)

    return e("Frame", {
        AutomaticSize = self.props.autoSize,
        BackgroundTransparency = 1,
        Size = self.props.size,
        Position = self.props.position,
        LayoutOrder = self.props.order,
    }, {
        content = Roact.createFragment(children),
        layout = e(UIListLayout, {
            direction = self.props.direction,
            spacing = self.props.spacing,
        }),
    })
end

return Component
