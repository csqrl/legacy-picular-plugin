local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioTheme: RoactComponent = require(script.Parent.StudioTheme)

local e = Roact.createElement

return function(props)
    props = props or {}

    return StudioTheme.use(function(_, styles)
        local direction: Enum.FillDirection? = props.direction or "y"
        local alignX: Enum.HorizontalAlignment? = props.alignX or props.align or "centre"
        local alignY: Enum.VerticalAlignment? = props.alignY or props.align or "centre"

        local padding: UDim = props.Padding or props.padding
            or props.spacing and UDim.new(0, props.spacing)
            or UDim.new(0, styles.spacing)

        if type(alignX) == "string" then
            alignX = Enum.HorizontalAlignment[
                alignX == "start" and "Left"
                or alignX == "end" and "Right"
                or "Center"
            ]
        end

        if type(alignY) == "string" then
            alignY = Enum.VerticalAlignment[
                alignY == "start" and "Top"
                or alignY == "end" and "Bottom"
                or "Center"
            ]
        end

        if type(props.direction) == "string" then
            direction = Enum.FillDirection[
                table.find({ "h", "x", "horizontal" }, direction) and "Horizontal" or "Vertical"
            ]
        end

        return e("UIListLayout", {
            Padding = padding,
            FillDirection = direction,
            HorizontalAlignment = alignX,
            VerticalAlignment = alignY,
            SortOrder = props.order or Enum.SortOrder.LayoutOrder,
        })
    end)
end
