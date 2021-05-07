local Studio: Studio = settings():GetService("Studio")
local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local e = Roact.createElement

local Context = Roact.createContext(nil)
local Component = Roact.Component:extend("StudioThemeProvider")

Component.defaultProps = {
    styles = {
        spacing = 8,
        borderRadius = 4,
        fontSize = 14,

        font = {
            light = Enum.Font.Gotham,
            default = Enum.Font.Gotham,
            bold = Enum.Font.GothamBold,
        },
    },
}

function Component:init()
    self.styles = Llama.Dictionary.mergeDeep(
        Component.defaultProps.styles,
        self.props.styles
    )

    self._themeChanged = Studio.ThemeChanged:Connect(function()
        self:setState({})
    end)
end

function Component:didUpdate(prevProps)
    if prevProps.styles ~= self.props.styles then
        self.styles = Llama.Dictionary.mergeDeep(
            Component.defaultProps.styles,
            self.props.styles
        )

        self:setState({})
    end
end

function Component:didMount()
    self:setState({})
end

function Component:willUnmount()
    self._themeChanged:Disconnect()
end

function Component:render()
    return e(Context.Provider, {
        value = {
            theme = Studio.Theme,
            styles = self.styles,
        }
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
