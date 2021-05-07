local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("TextLabel")

Component.defaultProps = {
    colour = "MainText", -- Color3 | Enum.StudioStyleGuideColor
    modifier = nil, -- Enum.StudioStyleGuideModifier
    order = nil, -- number
    truncate = false, -- boolean
    wrapped = false, -- boolean
    autoSize = nil, -- Enum.AutomaticSize
    text = "", -- string
    size = nil, -- UDim2
    position = nil, -- UDim2
    fontWeight = "normal", -- "normal" | "bold" | "light"
    transparency = nil, -- number
    alignX = Enum.TextXAlignment.Left, -- Enum.TextXAlignment
    alignY = Enum.TextYAlignment.Center, -- Enum.TextYAlignment
    richText = false, -- boolean
    textSize = nil, -- number
    fontSizeOffset = 0, -- number
    anchor = nil, -- Vector2
}

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
        local textColour = self.props.colour
        local textSize = self.props.textSize
        local font = styles.font.default

        if typeof(textColour) ~= "Color3" then
            textColour = theme:GetColor(textColour, self.props.modifier)
        end

        if textSize == nil then
            textSize = styles.fontSize + self.props.fontSizeOffset
        end

        if self.props.fontWeight == "bold" then
            font = styles.font.bold
        elseif self.props.fontWeight == "light" then
            font = styles.font.light
        end

        return e("TextLabel", {
            AutomaticSize = self.props.autoSize,
            AnchorPoint = self.props.anchor,
            BackgroundTransparency = 1,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            Font = font,
            RichText = self.props.richText,
            Text = self.props.text,
            TextColor3 = textColour,
            TextSize = textSize,
            TextTransparency = self.props.transparency,
            TextWrapped = self.props.wrapped,
            TextTruncate = self.props.truncate and Enum.TextTruncate.AtEnd or nil,
            TextXAlignment = self.props.alignX,
            TextYAlignment = self.props.alignY,
        }, self.props[Roact.Children])
    end)
end

return Component
