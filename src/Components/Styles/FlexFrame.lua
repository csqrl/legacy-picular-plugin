local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)

local UIListLayout: RoactComponent = require(script.Parent.UIListLayout)

local e = Roact.createElement

local Component = Roact.Component:extend("FlexFrame")

Component.defaultProps = {
    direction = "x", -- ("x" | "h" | "horizontal") | ("y" | "v" | "vertical")

    fixedSide = "start", -- "start" | "end"
    fixedSize = "auto", -- "auto" | number
    fixedItems = nil, -- { RoactElement }

    spacing = 0, -- number

    size = UDim2.fromScale(1, 1), -- UDim2
    anchor = nil, -- Vector2
    position = nil, -- UDim2
    autoSize = nil, -- Enum.AutomaticSize
    order = nil, -- number
}

function Component:init()
    local direction = table.find({ "y", "v", "vertical" }, self.props.direction) ~= nil
        and "y" or "x"

    self:setState({
        size = type(self.props.fixedSize) == "number" and self.props.fixedSize or 0,
        direction = direction,
    })

    self.onFixedSizeChanged = function(rbx: Frame)
        if self.props.fixedSize ~= "auto" then
            return
        end

        local absSize = rbx.AbsoluteSize

        if self.state.direction == "y" then
            self:setState({ size = absSize.Y })
        else
            self:setState({ size = absSize.X })
        end
    end
end

function Component:didUpdate(prevProps)
    if prevProps.fixedSize ~= self.props.fixedSize then
        self:setState({
            size = type(self.props.fixedSize) == "number" and self.props.fixedSize or 0,
        })
    end

    if prevProps.direction ~= self.props.direction then
        self:setState({
            direction = table.find({ "y", "v", "vertical" }, self.props.direction) ~= nil
                and "y" or "x",
        })
    end

    if prevProps.fixedItems ~= self.props.fixedItems then
        self:setState({})
    end
end

function Component:_getConfig()
    local config = {
        autoSize = Enum.AutomaticSize.X,
        fixedSize = UDim2.fromScale(0, 1),
        fixedOrder = self.props.fixedSide == "end" and 20 or 1,
        flexSize = UDim2.new(1, -self.state.size - self.props.spacing, 1, 0),
    }

    if self.state.direction == "y" then
        config.flexSize = UDim2.new(1, 0, 1, -self.state.size - self.props.spacing)
    end

    if self.props.fixedSize == "auto" then
        if self.state.direction == "y" then
            config.autoSize = Enum.AutomaticSize.Y
            config.fixedSize = UDim2.fromScale(1, 0)
        end
    else
        config.autoSize = Enum.AutomaticSize.None

        if self.props.direction == "y" then
            config.fixedSize = UDim2.new(1, 0, 0, self.props.fixedSize)
        else
            config.fixedSize = UDim2.new(0, self.props.fixedSize, 1, 0)
        end
    end

    return config
end

function Component:render()
    local config = self:_getConfig()

    return e("Frame", {
        AutomaticSize = self.props.autoSize,
        AnchorPoint = self.props.anchor,
        BackgroundTransparency = 1,
        Position = self.props.position,
        Size = self.props.size,
        LayoutOrder = self.props.order,
    }, {
        layout = e(UIListLayout, {
            spacing = self.props.spacing,
            direction = self.state.direction,
        }),

        fixedFrame = e("Frame", {
            AutomaticSize = config.autoSize,
            BackgroundTransparency = 1,
            Size = config.fixedSize,
            LayoutOrder = config.fixedOrder,

            [Roact.Change.AbsoluteSize] = self.onFixedSizeChanged,
        }, self.props.fixedItems),

        flexFrame = e("Frame", {
            BackgroundTransparency = 1,
            Size = config.flexSize,
            LayoutOrder = 10,
        }, self.props[Roact.Children]),
    })
end

return Component
