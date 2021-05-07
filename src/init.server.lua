local Components = script.Components
local Packages = script.Packages

local Roact: Roact = require(Packages.Roact)
local PluginFacade: RoactComponent = require(Components.PluginCore.PluginFacade)

local FacadeHandle: RoactTree = Roact.mount(
    Roact.createElement(PluginFacade, {
        plugin = plugin,
    }),
    nil,
    "PicularPluginHandle"
)

plugin.Unloading:Connect(function()
    Roact.unmount(FacadeHandle)
end)
