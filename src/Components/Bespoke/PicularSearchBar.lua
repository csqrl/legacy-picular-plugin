local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)

local Controls = require(Components.Controls)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("PicularSearchBar")

function Component:render()
    return e(Controls.TextInput, {
        placeholder = "Search for anything...",
        iconId = "Search",
        size = UDim2.new(1, 0, 0, 36),
    })
end

return Component
