local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PageBase")

Component.defaultProps = {
    gap = 1,
    padding = 1,
    centre = false,
}

function Component:init()
    self:setState({
        scrollVisible = false,
    })
end

function Component:render()
    return StudioTheme.use(function(_, styles)
        return Roact.createFragment({
            padding = e("UIPadding", {
                PaddingBottom = UDim.new(0, styles.spacing * self.props.padding),
                PaddingLeft = UDim.new(0, styles.spacing * self.props.padding),
                PaddingRight = UDim.new(0, styles.spacing * self.props.padding),
                PaddingTop = UDim.new(0, styles.spacing * self.props.padding),
            }),

            content = e("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                CanvasSize = UDim2.new(),
                ElasticBehavior = Enum.ElasticBehavior.Never,
                ScrollBarThickness = styles.spacing,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                ClipsDescendants = true,
                Size = UDim2.fromScale(1, 1),

                [Roact.Change.AbsoluteWindowSize] = function(rbx: ScrollingFrame)
                    if self.state.scrollVisible and rbx.AbsoluteWindowSize.X >= rbx.AbsoluteSize.X then
                        self:setState({ scrollVisible = false })
                    elseif not self.state.scrollVisible and rbx.AbsoluteWindowSize.X < rbx.AbsoluteSize.X then
                        self:setState({ scrollVisible = true })
                    end
                end,
            }, {
                layout = e("UIListLayout", {
                    Padding = UDim.new(0, styles.spacing * self.props.gap),
                    FillDirection = Enum.FillDirection.Vertical,
                    HorizontalAlignment = self.props.centre and Enum.HorizontalAlignment.Center or Enum.HorizontalAlignment.Left,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = self.props.centre and Enum.VerticalAlignment.Center or Enum.VerticalAlignment.Top,
                }),

                padding = self.state.scrollVisible and e("UIPadding", {
                    PaddingBottom = UDim.new(),
                    PaddingLeft = UDim.new(),
                    PaddingRight = UDim.new(0, styles.spacing * self.props.padding),
                    PaddingTop = UDim.new(),
                }) or nil,

                content = Roact.createFragment(self.props[Roact.Children]),
            }),
        })
    end)
end

return Component
