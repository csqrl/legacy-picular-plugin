local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)
local TextLabel = require(Components.TextLabel)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("SectionHeader")

Component.defaultProps = {
    title = "Section Title",
    subtitle = "Section Subtitle",

    boldTitle = true,
    modifier = nil,

    size = UDim2.fromScale(1, 0),
    position = nil,
    order = nil,
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
                Padding = UDim.new(0, styles.spacing * .5),
                FillDirection = Enum.FillDirection.Vertical,
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
            }),

            title = e(TextLabel, {
                colour = "MainText",
                modifier = self.props.modifier,
                label = self.props.title,
                fontWeight = self.props.boldTitle and "bold" or nil,
                order = 10,
            }),

            subtitle = e(TextLabel, {
                colour = "DimmedText",
                modifier = self.props.modifier,
                label = self.props.subtitle,
                order = 20,
            }),
        })
    end)
end

return Component
