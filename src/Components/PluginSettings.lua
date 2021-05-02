local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

local PluginSettings = require(Root.Services.PluginSettings)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginSettings")

function Component:init()
    self.event = PluginSettings.Changed:Connect(function()
        self:setState({})
    end)
end

function Component:didMount()
    self:setState({})
end

function Component:willUnmount()
    self.event:Disconnect()
end

function Component:render()
    return self.props.render(PluginSettings)
end

function Component.use(render)
    return e(Component, {
        render = render,
    })
end

return Component
