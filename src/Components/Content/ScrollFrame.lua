local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)

local e = Roact.createElement

local Component = Roact.Component:extend("ScrollFrame")

Component.defaultProps = {
    size = UDim2.fromScale(1, 1), -- UDim2
    anchor = nil, -- Vector2
    position = nil, -- UDim2
    order = nil, -- number
}

function Component:init()
    self:setState({
        scrollbarVisible = false,
    })

    self.onWindowSizeChanged = function(rbx: ScrollingFrame)
        if self.state.scrollbarVisible and rbx.AbsoluteWindowSize.X >= rbx.AbsoluteSize.X then
            self:setState({ scrollbarVisible = false })
        elseif not self.state.scrollbarVisible and rbx.AbsoluteWindowSize.X < rbx.AbsoluteSize.X then
            self:setState({ scrollbarVisible = true })
        end
    end
end

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        return e("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            ElasticBehavior = Enum.ElasticBehavior.Never,
            ScrollBarThickness = styles.spacing,
            ScrollingDirection = Enum.ScrollingDirection.Y,
            VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Size = self.props.size,
            Position = self.props.position,
            AnchorPoint = self.props.anchor,
            LayoutOrder = self.props.order,

            -- TODO: Implement native-style scrollbar
            ScrollBarImageColor3 = theme:GetColor("Border"),
            BottomImage = "rbxasset://textures/ui/InGameMenu/WhiteSquare.png",
            MidImage = "rbxasset://textures/ui/InGameMenu/WhiteSquare.png",
            TopImage = "rbxasset://textures/ui/InGameMenu/WhiteSquare.png",

            [Roact.Change.AbsoluteWindowSize] = self.onWindowSizeChanged,
        }, {
            padding = self.state.scrollbarVisible and e(Styles.UIPadding, { 0, styles.spacing, 0, 0 }),
            content = Roact.createFragment(self.props[Roact.Children]),
        })
    end)
end

return Component
