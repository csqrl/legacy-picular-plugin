local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local Resources = require(Root.Data.Resources)
local Config = require(Root.Data.Config)

local StudioTheme = require(Components.StudioTheme)
local StudioPlugin = require(Components.StudioPlugin)
local PluginContext = StudioPlugin.Context.Plugin

local AppComponent = require(Components.App)

local e = Roact.createElement
local fmt = string.format

local Component: RoactComponent = Roact.Component:extend("PluginFacade")

Component.defaultProps = {
    plugin = nil,
}

function Component:init()
    self:setState({
        active = false,
    })
end

function Component:render()
    return Roact.createElement(PluginContext.Provider, {
        value = self.props.plugin,
    }, {
        toolbar = e(StudioPlugin.Toolbar, {
            name = Config.PluginToolbar,
        }, {
            toggleButton = e(StudioPlugin.Button, {
                id = fmt("%s:%s", Config.UUID, "plugin-toggle"),
                tooltip = Config.PluginTooltip,
                icon = Resources.PluginIcon,
                label = Config.PluginName,
                active = self.state.active,

                onClick = function()
                    self:setState({
                        active = not self.state.active,
                    })
                end,
            }),
        }),

        widget = e(StudioPlugin.Widget, {
            enabled = self.state.active,

            title = Config.PluginName,
            id = fmt("%s:%s", Config.UUID, "widget"),

            floatSize = Vector2.new(300, 450),
            minSize = Vector2.new(295, 235),

            onInit = function(enabled: boolean)
                self:setState({ active = enabled })
            end,

            onToggle = function(enabled: boolean)
                self:setState({ active = enabled })
            end,
        }, {
            themeProvider = e(StudioTheme, nil, {
                app = e(AppComponent),
            }),
        }),
    })
end

return Component
