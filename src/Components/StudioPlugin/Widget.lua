local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Context = require(script.Parent.Context)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginWidget")

Component.defaultProps = {
    plugin = nil,

    enabled = false,
    id = nil,
    title = nil,

    initDockState = Enum.InitialDockState.Left,
    overrideEnabledRestore = false,
    floatSize = Vector2.new(),
    minSize = Vector2.new(),

    onInit = nil,
    onToggle = nil,
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
    return e(Context.Widget.Provider, {
        value = self.widget,
    }, {
        widget = e(Roact.Portal, {
            target = self.widget,
        }, self.props[Roact.Children]),
    })
end

function Component.wrap(props)
    return e(Context.Plugin.Consumer, {
        render = function(plugin: Plugin)
            return e(Component, Llama.Dictionary.merge(props, {
                plugin = plugin,
            }))
        end
    })
end

return Component.wrap
