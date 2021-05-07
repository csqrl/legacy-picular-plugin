local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local PluginSettings = require(script.Parent.PluginSettings)
local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local StudioPlugin = require(Components.StudioPlugin)

local e = Roact.createElement

local Context = Roact.createContext(nil)
local Component = Roact.Component:extend("PluginSettingsProvider")

Component.defaultProps = {
    plugin = nil, -- Plugin
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    self.settings = PluginSettings.new(plugin)
    self.settings.Changed:Connect(function()
        self:setState({})
    end)
end

function Component:willUnmount()
    self.settings:Destroy()
end

function Component:render()
    return e(Context.Provider, {
        value = self.settings,
    }, self.props[Roact.Children])
end

function Component.use(render)
    return e(Context.Consumer, {
        render = render,
    })
end

local function ProvidePluginSettings(props)
    props = props or {}

    return e(StudioPlugin.Contexts.Plugin.Consumer, {
        render = function(plugin: Plugin)
            return e(Component, Llama.Dictionary.merge(props, {
                plugin = plugin,
            }))
        end,
    })
end

return {
    use = Component.use,
    Provider = ProvidePluginSettings,
}
