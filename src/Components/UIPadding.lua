local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Root.Components.StudioTheme)

return function(props)
    props = props or {}

    return StudioTheme.use(function(_, styles)
        local offset = props.offset or 1

        local top = (props.top or props[1] or styles.spacing) * offset
        local right = top

        if props.right or props[2] then
            right = (props.right or props[2]) * offset
        end

        local bottom = top
        local left = right

        if props.bottom or props[3] then
            bottom = (props.bottom or props[3]) * offset
        end

        if props.left or props[4] then
            left = (props.left or props[4]) * offset
        end

        return Roact.createElement("UIPadding", {
            PaddingTop = UDim.new(0, top),
            PaddingRight = UDim.new(0, right),
            PaddingBottom = UDim.new(0, bottom),
            PaddingLeft = UDim.new(0, left),
        })
    end)
end
