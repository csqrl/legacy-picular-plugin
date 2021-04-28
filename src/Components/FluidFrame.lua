local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local e = Roact.createElement

local Component = Roact.Component:extend("FluidFrame")

Component.defaultProps = {
    direction = "x", -- "x" | "y"

    fixedSide = "start", -- "start" | "end"
    fixedSize = "auto", -- "auto" | number,
    fixedItems = nil, -- children

    spacing = 0, -- number
}

function Component:init(props)
    self:setState({
        size = type(props.fixedSize) == "number" and props.fixedSize or 0,
    })

    self.onFixedSizeChanged = function(rbx)
        if self.props.fixedSize ~= "auto" then
            return
        end

        local absoluteSize = rbx.AbsoluteSize

        if self.props.direction == "y" then
            self:setState({ size = absoluteSize.Y })
        else
            self:setState({ size = absoluteSize.X })
        end
    end

    self.fixedRef = Roact.createRef()
end

function Component:didUpdate(prevProps)
    local props = self.props

    if prevProps.fixedSize ~= props.fixedSize then
        self:setState({
            size = type(props.fixedSize) == "number" and props.fixedSize or 0
        })
    end
end

function Component:getConfig()
    local props, state = self.props, self.state

    local config = {
        automaticSize = Enum.AutomaticSize.X,
        fixedSize = UDim2.fromScale(0, 1),
        fillDirection = props.direction == "y" and Enum.FillDirection.Vertical or Enum.FillDirection.Horizontal,
        fixedOrder = props.fixedSide == "start" and 10 or 30,
        fluidSize = UDim2.new(1, -state.size - props.spacing, 1, 0),
    }

    config.fluidSize = props.direction == "x" and UDim2.new(1, -state.size - props.spacing, 1, 0)
        or UDim2.new(1, 0, 1, -state.size - props.spacing)

    if props.fixedSize == "auto" then
        if props.direction == "y" then
            config.automaticSize = Enum.AutomaticSize.Y
            config.fixedSize = UDim2.fromScale(1, 0)
        end
    else
        config.automaticSize = Enum.AutomaticSize.None

        if props.direction == "y" then
            config.fixedSize = UDim2.new(1, 0, 0, props.fixedSize)
        else
            config.fixedSize = UDim2.new(0, props.fixedSize, 1, 0)
        end
    end

    return config
end

function Component:didMount()
    local fixedFrame = self.fixedRef:getValue()

    if fixedFrame then
        self.onFixedSizeChanged(fixedFrame)
    end
end

function Component:render()
    local config = self:getConfig()
    local props = self.props

    return e("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
    }, {
        layout = e("UIListLayout", {
            Padding = UDim.new(0, props.spacing),
            FillDirection = config.fillDirection,
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),

        fixedFrame = e("Frame", {
            AutomaticSize = config.automaticSize,
            BackgroundTransparency = 1,
            Size = config.fixedSize,
            LayoutOrder = config.fixedOrder,

            [Roact.Ref] = self.fixedRef,
            [Roact.Change.AbsoluteSize] = self.onFixedSizeChanged,
        }, props.fixedItems),

        fluidFrame = e("Frame", {
            BackgroundTransparency = 1,
            Size = config.fluidSize,
            LayoutOrder = 20,
        }, props[Roact.Children]),
    })
end

return Component
