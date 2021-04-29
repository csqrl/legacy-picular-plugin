local Root = script.Parent.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Flipper = require(Root.Packages.Flipper)

local StudioTheme = require(Components.StudioTheme)
local Icon = require(Components.Icon)
local TextLabel = require(Components.TextLabel)
local Section = require(Components.Section)

local e = Roact.createElement

local Component = Roact.Component:extend("Checkbox")

Component.defaultProps = {
    label = nil,
    caption = nil,

    checked = false,
    disabled = false,

    size = UDim2.fromScale(1, 0),
    position = nil,
    order = nil,

    onClick = nil,
}

function Component:init()
    local initState = self.props.checked and 0 or 1

    self.motor = Flipper.SingleMotor.new(initState)

    local binding, setBinding = Roact.createBinding(self.motor:getValue())
    self.binding = binding

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
        if input.UserInputType.Name:match("MouseButton%d+") or input.UserInputType == Enum.UserInputType.Touch then
            self:setState({ press = true })
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            self:setState({ hover = true })
        end
    end

    self.onInputEnded = function(_, input: InputObject)
        if input.UserInputType.Name:match("MouseButton%d+") or input.UserInputType == Enum.UserInputType.Touch then
            self:setState({ press = false })
        elseif input.UserInputType == Enum.UserInputType.MouseMovement then
            self:setState({ hover = false })
        end
    end

    self.motor:onStep(setBinding)
end

function Component:didUpdate(prevProps)
    if self.props.checked ~= prevProps.checked then
        local state = self.props.checked and 0 or 1

        self.motor:setGoal(Flipper.Spring.new(state, {
            frequency = 5,
            dampingRatio = .3,
        }))
    end
end

function Component:render()
    local modifier = Enum.StudioStyleGuideModifier.Default

    if self.props.disabled then
        modifier = Enum.StudioStyleGuideModifier.Disabled
    elseif self.state.press then
        modifier = Enum.StudioStyleGuideModifier.Pressed
    elseif self.state.hover then
        modifier = Enum.StudioStyleGuideModifier.Hover
    end

    local checkModifier = modifier

    if not self.props.disabled and self.props.checked then
        checkModifier = Enum.StudioStyleGuideModifier.Selected
    end

    return StudioTheme.use(function(theme: StudioTheme, styles)
        return e("TextButton", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            Text = "",

            [Roact.Event.Activated] = self.onClick,
            [Roact.Event.InputBegan] = self.onInputBegan,
            [Roact.Event.InputEnded] = self.onInputEnded,
        }, {
            layout = e("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, styles.spacing * .5),
                HorizontalAlignment = Enum.HorizontalAlignment.Left,
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Top,
            }),

            checkbox = e("Frame", {
                BackgroundColor3 = theme:GetColor("CheckedFieldBorder", checkModifier),
                BorderSizePixel = 0,
                LayoutOrder = 100,
                Size = UDim2.fromOffset(24, 24),
            }, {
                corner = e("UICorner", {
                    CornerRadius = UDim.new(0, styles.spacing * .5),
                }),

                padding = e("UIPadding", {
                    PaddingBottom = UDim.new(0, 1),
                    PaddingLeft = UDim.new(0, 1),
                    PaddingRight = UDim.new(0, 1),
                    PaddingTop = UDim.new(0, 1),
                }),

                container = e("Frame", {
                    BackgroundColor3 = theme:GetColor("CheckedFieldBackground", checkModifier),
                    BorderSizePixel = 0,
                    ClipsDescendants = true,
                    Size = UDim2.fromScale(1, 1),
                }, {
                    corner = e("UICorner", {
                        CornerRadius = UDim.new(0, (styles.spacing * .5) - 1),
                    }),

                    indicator = e(Icon, {
                        id = "Tick",
                        colour = theme:GetColor("CheckedFieldIndicator", checkModifier),
                        anchor = Vector2.new(.5, .5),
                        position = UDim2.fromScale(.5, .5),
                        size = self.binding:map(function(value)
                            local scale = 16 / 22
                            return UDim2.fromScale(scale, scale):Lerp(UDim2.new(), value)
                        end),
                        transparency = self.binding,
                    }),
                }),
            }),

            labels = e(Section.Header, {
                title = self.props.label,
                subtitle = self.props.caption,
                boldTitle = false,
                modifier = modifier,
                size = UDim2.new(1, -(24 + (styles.spacing * .5)), 0, 24),
                order = 200,
            }, {
                padding = e("UIPadding", {
                    PaddingLeft = UDim.new(0, styles.spacing),
                    PaddingRight = UDim.new(0, styles.spacing),
                }),
            }),

            -- labels = e("Frame", {
            --     AutomaticSize = Enum.AutomaticSize.Y,
            --     BackgroundTransparency = 1,
            --     LayoutOrder = 200,
            --     Size = UDim2.new(1, -(24 + (styles.spacing * .5)), 0, 24),
            -- }, {
            --     padding = e("UIPadding", {
            --         PaddingLeft = UDim.new(0, styles.spacing),
            --         PaddingRight = UDim.new(0, styles.spacing),
            --     }),

            --     layout = e("UIListLayout", {
            --         FillDirection = Enum.FillDirection.Vertical,
            --         Padding = UDim.new(0, styles.spacing * .5),
            --         HorizontalAlignment = Enum.HorizontalAlignment.Left,
            --         SortOrder = Enum.SortOrder.LayoutOrder,
            --         VerticalAlignment = Enum.VerticalAlignment.Center,
            --     }),

            --     label = self.props.label and e(TextLabel, {
            --         label = self.props.label,
            --         colour = "MainText",
            --         modifier = modifier,
            --         order = 100,
            --     }) or nil,

            --     caption = self.props.caption and e(TextLabel, {
            --         label = self.props.caption,
            --         colour = "DimmedText",
            --         modifier = modifier,
            --         textSize = styles.fontSize - 2,
            --         order = 200,
            --     }) or nil,
            -- }),
        })
    end)
end

return Component
