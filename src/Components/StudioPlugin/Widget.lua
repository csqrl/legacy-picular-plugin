local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local Contexts = require(script.Parent.Contexts)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginWidget")

Component.defaultProps = {
    plugin = nil, -- Plugin

    enabled = false, -- boolean
    id = nil, -- string
    title = nil, -- string

    initDockState = Enum.InitialDockState.Left, -- Enum.InitialDockState
    overrideEnabledRestore = false, -- boolean
    floatSize = Vector2.new(), -- Vector2
    minSize = Vector2.new(), -- Vector2

    onInit = nil, -- callback(boolean)
    onToggle = nil, -- callback(boolean)
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    local widgetInfo = DockWidgetPluginGuiInfo.new(
        self.props.initDockState,
        self.props.enabled,
        self.props.overrideEnabledRestore,
        self.props.floatSize.X,
        self.props.floatSize.Y,
        self.props.minSize.X,
        self.props.minSize.Y
    )

    self.widget = plugin:CreateDockWidgetPluginGui(self.props.id, widgetInfo)

    self.widget.Name = self.props.id
    self.widget.Title = self.props.title
    self.widget.ResetOnSpawn = false
    self.widget.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if type(self.props.onInit) == "function" then
        self.props.onInit(self.widget.Enabled)
    end

    self.widget:GetPropertyChangedSignal("Enabled"):Connect(function()
        if type(self.props.onToggle) == "function" then
            self.props.onToggle(self.widget.Enabled)
        end
    end)
end

function Component:willUnmount()
    self.widget:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.enabled ~= self.props.enabled then
        self.widget.Enabled = self.props.enabled
    end
end

function Component:render()
    return e(Contexts.Widget.Provider, {
        value = self.widget,
    }, {
        widget = e(Roact.Portal, {
            target = self.widget,
        }, self.props[Roact.Children]),
    })
end

return function(props)
    props = props or {}

    return e(Contexts.Plugin.Consumer, {
        render = function(plugin: Plugin)
            return e(Component, Llama.Dictionary.merge(props, {
                plugin = plugin,
            }))
        end,
    })
end
