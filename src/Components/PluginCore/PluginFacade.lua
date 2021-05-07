local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Styles = require(Components.Styles)
local StudioPlugin = require(Components.StudioPlugin)
local PluginSettings = require(Components.Providers.PluginSettings)
local AppCanvas = require(Components.AppCanvas)

local e = Roact.createElement

local Component = Roact.Component:extend("PluginFacade")

Component.defaultProps = {
    plugin = nil, -- Plugin
}

function Component:init()
    self:setState({
        widgetActive = false,
    })

    self.widgetToggleClicked = function()
        self:setState({ widgetActive = not self.state.widgetActive })
    end
end

function Component:render()
    return e(StudioPlugin.Contexts.Plugin.Provider, {
        value = self.props.plugin,
    }, {
        toolbar = e(StudioPlugin.Toolbar, {
            name = "Picular",
        }, {
            widgetToggle = e(StudioPlugin.Button, {
                id = "main-widget-toggle",
                tooltip = "Find the colour of anything; apply it to everything",
                icon = "rbxassetid://6060872355",
                label = "Picular",
                active = self.state.widgetActive,
                onClick = self.widgetToggleClicked,
            }),
        }),

        settingsProvider = e(PluginSettings.Component.Provider, nil, {
            mainWidget = e(StudioPlugin.Widget, {
                enabled = self.state.widgetActive,
                title = "Picular",
                id = "picular-main-widget",
                floatSize = Vector2.new(308, 450),
                minSize = Vector2.new(298, 235),

                onInit = function(enabled: boolean)
                    self:setState({ widgetActive = enabled })
                end,

                onToggle = function(enabled: boolean)
                    self:setState({ widgetActive = enabled })
                end,
            }, {
                themeProvider = e(Styles.StudioTheme, nil, {
                    app = e(AppCanvas),
                }),
            }),
        }),
    })
end

return Component
