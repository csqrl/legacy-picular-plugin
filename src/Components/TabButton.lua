local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)
local Icon = require(Components.Icon)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("TabButton")

Component.defaultProps = {
    active = false,

    position = UDim2.new(),
    size = UDim2.new(1, 0, 0, 36),
    order = 1,

    label = nil,
    icon = nil,
    iconAlign = Enum.HorizontalAlignment.Left,

    onClick = nil,
}

local function createBorder(edge: Enum.NormalId, colour: Color3): RoactElement
    local anchor: Vector2, position: UDim2, size: UDim2, zindex: number = nil, nil, nil, 10

    if edge == Enum.NormalId.Left then
        size = UDim2.new(0, 2, 1, 0)
    elseif edge == Enum.NormalId.Right then
        anchor = Vector2.new(1, 0)
        position = UDim2.fromScale(1, 0)
        size = UDim2.new(0, 2, 1, 0)
    elseif edge == Enum.NormalId.Bottom then
        anchor = Vector2.new(0, 1)
        position = UDim2.fromScale(0, 1)
        size = UDim2.new(1, 0, 0, 2)
    elseif edge == Enum.NormalId.Top then
        size = UDim2.new(1, 0, 0, 2)
        zindex = 1
    end

    return e("Frame", {
        AnchorPoint = anchor,
        BackgroundColor3 = colour,
        BorderSizePixel = 0,
        Position = position,
        Size = size,
        ZIndex = zindex,
    })
end

function Component:init()
    self:setState({
        hover = false,
        press = false,
    })

    self.onClick = function(...)
        if not self.props.disabled and type(self.props.onClick) == "function" then
            self.props.onClick(...)
        end
    end

    self.onInputBegan = function(_, input: InputObject)
        if input.UserInputType.Name:match("MouseButton%d+") or input == Enum.UserInputType.Touch then
            self:setState({ press = true })
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            self:setState({ hover = true })
        end
    end

    self.onInputEnded = function(_, input: InputObject)
        if input.UserInputType.Name:match("MouseButton%d+") or input == Enum.UserInputType.Touch then
            self:setState({ press = false })
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            self:setState({ hover = false })
        end
    end
end

function Component:render()
    local modifier = Enum.StudioStyleGuideModifier.Default

    if self.props.disabled then
        modifier = Enum.StudioStyleGuideModifier.Disabled
    elseif self.props.active then
        modifier = Enum.StudioStyleGuideModifier.Selected
    elseif self.state.press then
        modifier = Enum.StudioStyleGuideModifier.Pressed
    elseif self.state.hover then
        modifier = Enum.StudioStyleGuideModifier.Hover
    end

    return StudioTheme.use(function(theme: StudioTheme, styles)
        return e("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = theme:GetColor("RibbonTab", modifier),
            BorderSizePixel = 0,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            ClipsDescendants = true,
            Text = "",

            [Roact.Event.Activated] = self.onClick,
            [Roact.Event.InputBegan] = self.onInputBegan,
            [Roact.Event.InputEnded] = self.onInputEnded,
        }, {
            borders = Roact.createElement("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                ClipsDescendants = true,
            }, {
                top = self.props.active and createBorder(Enum.NormalId.Top, theme:GetColor("LinkText", modifier)),
                right = self.props.active and createBorder(Enum.NormalId.Right, theme:GetColor("Border", modifier)),
                bottom = not self.props.active and createBorder(Enum.NormalId.Bottom, theme:GetColor("Border", modifier)),
                left = self.props.active and createBorder(Enum.NormalId.Left, theme:GetColor("Border", modifier)),
            }),

            content = Roact.createElement("Frame", {
                AnchorPoint = Vector2.new(.5, .5),
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(.5, .5),
                Size = UDim2.new(1, -(styles.spacing * 2), 1, -(styles.spacing * 2)),
                ZIndex = 10,
            }, {
                layout = e("UIListLayout", {
                    Padding = UDim.new(0, styles.spacing),
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                }),

                icon = self.props.icon and e(Icon, {
                    id = self.props.icon,
                    colour = theme:GetColor("ButtonText", modifier),
                }),

                label = self.props.label and e("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    LayoutOrder = 20,
                    Size = UDim2.fromOffset(0, styles.fontSize),
                    ClipsDescendants = true,
                    Font = styles.font,
                    Text = self.props.label,
                    TextColor3 = theme:GetColor("ButtonText", modifier),
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextSize = styles.fontSize,
                    TextWrapped = false,
                    TextXAlignment = Enum.TextXAlignment.Center,
                    TextYAlignment = Enum.TextYAlignment.Center,
                }),
            }),
        })
    end)
end

return Component
