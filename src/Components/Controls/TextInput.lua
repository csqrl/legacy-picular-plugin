local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Flipper = require(PluginRoot.Packages.Flipper)

local Styles = require(Components.Styles)
local Util = require(Components.Util)
local Content = require(Components.Content)

local e = Roact.createElement

local Component = Roact.Component:extend("TextInput")

Component.defaultProps = {
    disabled = false, -- boolean
    order = nil, -- number
    position = nil, -- UDim2
    size = UDim2.fromOffset(36, 36), -- UDim2
    placeholder = nil, -- string
    clearOnFocus = false, -- boolean
    truncate = false, -- boolean
    iconId = nil,
}

function Component:init()
    Util.ButtonBase.init(self)

    self.onClick = function()
        local textInput: TextBox = self.textInputRef:getValue()

        if textInput then
            textInput:CaptureFocus()
        end
    end

    self.onInputFocus = function()
        self:setState({ active = true })

        self.motor:setGoal(Flipper.Spring.new(1, {
            frequency = 5,
            dampingRatio = 1,
        }))
    end

    self.onInputBlur = function()
        self:setState({
            active = false,
            hover = false,
            press = false
        })

        self.motor:setGoal(Flipper.Spring.new(0, {
            frequency = 4,
            dampingRatio = 1,
        }))
    end

    self.onTextChanged = function(rbx: TextBox)
        if #rbx.Text > 0 and not self.state.hasText then
            self:setState({ hasText = true })
        elseif #rbx.Text == 0 and self.state.hasText then
            self:setState({ hasText = false })
        end
    end

    self.textInputRef = Roact.createRef()
    self.motor = Flipper.SingleMotor.new(0)

    local binding, setBinding = Roact.createBinding(self.motor:getValue())
    self.binding = binding

    self.motor:onStep(setBinding)
end

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        local modifier, secondaryModifier = Util.ButtonBase.getModifier(self)

        return Util.ButtonBase.render(self, e("ImageButton", {
            AutoButtonColor = false,
            BackgroundColor3 = theme:GetColor("InputFieldBorder", modifier),
            BorderSizePixel = 0,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            ClipsDescendants = true,
            Image = "",
        }, {
            borderRadius = e(Styles.UICorner),
            borderPadding = e(Styles.UIPadding, { 1 }),

            rootContainer = e("Frame", {
                BackgroundColor3 = theme:GetColor("InputFieldBackground", modifier),
                Size = UDim2.fromScale(1, 1),
            }, {
                padding = e(Styles.UIPadding, { styles.spacing * .5, styles.spacing }),
                borderRadius = e(Styles.UICorner, { offset = -1 }),

                icon = self.props.iconId and e(Content.Icon, {
                    id = self.props.iconId,
                    modifier = self.state.hasText and secondaryModifier or modifier,
                    colour = self.state.hasText and "MainText" or "DimmedText",

                    anchor = self.binding:map(function(value: number)
                        return Vector2.new(0, .5):Lerp(Vector2.new(1, .5), value)
                    end),

                    position = self.binding:map(function(value: number)
                        return UDim2.fromScale(0, .5):Lerp(UDim2.fromScale(1, .5), value)
                    end),
                }),

                textInput = e("TextBox", {
                    Active = not self.props.disabled,
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, self.props.iconId and (-16 - styles.spacing) or 0, 0, 0),
                    ClearTextOnFocus = self.props.clearOnFocus,
                    TextEditable = not self.props.disabled,
                    ClipsDescendants = true,
                    Font = styles.font.default,
                    PlaceholderColor3 = theme:GetColor("DimmedText", modifier),
                    PlaceholderText = self.props.placeholder,
                    TextColor3 = theme:GetColor("MainText", secondaryModifier),
                    TextSize = styles.fontSize,
                    TextTruncate = self.props.truncate and Enum.TextTruncate.AtEnd or nil,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Text = "",

                    AnchorPoint = self.props.iconId and self.binding:map(function(value: number)
                        return Vector2.new(1, .5):Lerp(Vector2.new(0, .5), value)
                    end) or Vector2.new(0, .5),
                    Position = self.props.iconId and self.binding:map(function(value: number)
                        return UDim2.fromScale(1, .5):Lerp(UDim2.fromScale(0, .5), value)
                    end) or UDim2.fromScale(0, .5),

                    [Roact.Ref] = self.textInputRef,

                    [Roact.Event.Focused] = self.onInputFocus,
                    [Roact.Event.FocusLost] = self.onInputBlur,
                    [Roact.Change.Text] = self.onTextChanged,
                }),
            }),
        }))
    end)
end

return Component
