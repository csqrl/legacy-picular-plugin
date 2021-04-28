local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local StudioTheme = require(Components.StudioTheme)
local TabButton = require(script.Parent.TabButton)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("TabBar")

Component.defaultProps = {
    size = UDim2.new(1, 0, 0, 36),
    position = UDim2.new(),
}

function Component:render()
    local tabCount = Llama.Dictionary.count(self.props[Roact.Children], function(element: RoactElement)
        return element.component == TabButton
    end)

    local children = Llama.Dictionary.map(self.props[Roact.Children], function(element: RoactElement)
        if element.component ~= TabButton then
            return element
        end

        return e(element.component, Llama.Dictionary.merge(element.props, {
            size = UDim2.fromScale(1 / tabCount, 1),
        }))
    end)

    return StudioTheme.use(function(theme: StudioTheme)
        return e("Frame", {
            BackgroundColor3 = theme:GetColor("RibbonTab"),
            BorderSizePixel = 0,
            Size = self.props.size,
            Position = self.props.position,
            ClipsDescendants = true,
        }, {
            layout = e("UIListLayout", {
                Padding = UDim.new(),
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
            }),

            tabs = Roact.createFragment(children),
        })
    end)
end

return Component
