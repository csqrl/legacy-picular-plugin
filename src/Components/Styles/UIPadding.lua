local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local StudioTheme: RoactComponent = require(script.Parent.StudioTheme)

local e = Roact.createElement
local max = math.max

return function(props)
    props = props or {}

    return StudioTheme.use(function(_, styles)
        local offset = props.offset or 1

        local top = max((props.top or props[1] or styles.spacing) * offset, 0)
        local right = top

        if props.right or props[2] then
            right = max((props.right or props[2]) * offset, 0)
        end

        local bottom = top
        local left = right

        if props.bottom or props[3] then
            bottom = max((props.bottom or props[3]) * offset, 0)
        end

        if props.left or props[4] then
            left = max((props.left or props[4]) * offset, 0)
        end

        return e("UIPadding", {
            PaddingTop = UDim.new(0, top),
            PaddingRight = UDim.new(0, right),
            PaddingBottom = UDim.new(0, bottom),
            PaddingLeft = UDim.new(0, left),
        })
    end)
end
