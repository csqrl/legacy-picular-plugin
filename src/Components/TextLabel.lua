local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("TextLabel")

Component.defaultProps = {
    label = "",

    colour = "MainText",
    modifier = "Default",

    fontWeight = "normal", -- "normal" | "bold"
    textSize = nil,
    richText = false,

    autoSize = true,
    position = nil,
    size = UDim2.new(1, 0, 0, 0),
    transparency = 0,
    order = nil,

    alignX = Enum.TextXAlignment.Left,
    alignY = Enum.TextYAlignment.Center,
}

function Component:render()
    return StudioTheme.use(function(theme: StudioTheme, styles)
        local colour = self.props.colour
        local font = styles.font

        if type(colour) == "string" then
            colour = theme:GetColor(colour, self.props.modifier)
        end

        if self.props.fontWeight == "bold" then
            font = styles.fontBold
        end

        return e("TextLabel", {
            AutomaticSize = self.props.autoSize and Enum.AutomaticSize.Y or nil,
            BackgroundTransparency = 1,
            LayoutOrder = self.props.order,
            Position = self.props.position,
            Size = self.props.size,
            Font = font,
            RichText = self.props.richText,
            Text = self.props.label,
            TextColor3 = colour,
            TextSize = self.props.textSize or styles.fontSize,
            TextTransparency = self.props.transparency,
            TextWrapped = true,
            TextXAlignment = self.props.alignX,
            TextYAlignment = self.props.alignY,
        })
    end)
end

return Component
