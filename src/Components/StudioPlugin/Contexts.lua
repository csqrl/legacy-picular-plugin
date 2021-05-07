local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)

return {
    Plugin = Roact.createContext(nil),
    Toolbar = Roact.createContext(nil),
    Widget = Roact.createContext(nil),
    Settings = Roact.createContext(nil),
}
