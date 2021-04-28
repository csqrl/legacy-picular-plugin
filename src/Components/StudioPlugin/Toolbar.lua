local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Context = require(script.Parent.Context)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginToolbar")

Component.defaultProps = {
    plugin = nil,
    name = nil,
}

function Component:init()
    local plugin: Plugin = self.props.plugin

    self.toolbar = plugin:CreateToolbar(self.props.name)
end

function Component:willUnmount()
    self.toolbar:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.name ~= self.props.name then
        self.toolbar.Name = self.props.name
    end
end

function Component:render()
    return e(Context.Toolbar.Provider, {
        value = self.toolbar,
    }, self.props[Roact.Children])
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
