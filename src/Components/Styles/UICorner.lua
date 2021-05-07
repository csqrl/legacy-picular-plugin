local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioTheme: RoactComponent = require(script.Parent.StudioTheme)

local e = Roact.createElement
local max = math.max

return function(props)
    props = props or {}

    return StudioTheme.use(function(_, styles)
        local radius = props.CornerRadius
            or props.radius and UDim.new(0, props.radius)
            or UDim.new(0, styles.borderRadius)

        if type(props.offset) == "number" then
            if props.offset < 0 then
                radius = UDim.new(radius.Scale, max(radius.Offset + props.offset, 0))
            else
                radius = UDim.new(radius.Scale, max(radius.Offset * props.offset, 0))
            end
        end

        return e("UICorner", {
            CornerRadius = radius,
        })
    end)
end
