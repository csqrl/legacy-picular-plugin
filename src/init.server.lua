local Roact: Roact = require(script.Packages.Roact)

local PluginFacade: RoactComponent = require(script.Components.PluginFacade)
local FacadeElement: RoactElement = Roact.createElement(PluginFacade, {
    plugin = plugin,
})

local RoactHandle: RoactTree = Roact.mount(FacadeElement, nil, "PicularPluginHandle")

plugin.Unloading:Connect(function()
    Roact.unmount(RoactHandle)
end)
