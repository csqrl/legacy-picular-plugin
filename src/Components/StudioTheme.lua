local Studio: Studio = settings():GetService("Studio")

local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local e = Roact.createElement

local Context: RoactContext = Roact.createContext()
local Component: RoactComponent = Roact.Component:extend("StudioTheme")

Component.defaultProps = {
    styles = {
        spacing = 8,
        corners = 4,

        fontSize = 14,
        font = Enum.Font.Gotham,
        fontBold = Enum.Font.GothamBold,
    },
}

function Component:init()
    self:setState({ theme = Studio.Theme })

    self.themeEvent = Studio.ThemeChanged:Connect(function()
        self:setState({ theme = Studio.Theme })
    end)
end

function Component:willUnmount()
    self.themeEvent:Disconnect()
end

function Component:render()
    return e(Context.Provider, {
        value = {
            theme = self.state.theme,
            styles = self.props.styles,
        },
    }, self.props[Roact.Children])
end

function Component.use(render)
    return e(Context.Consumer, {
        render = function(values)
            return render(values.theme, values.styles)
        end,
    })
end

return Component
