local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)

local StudioTheme = require(Components.StudioTheme)
local FluidFrame = require(Components.FluidFrame)
local TabBar = require(Components.TabBar)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("App")

function Component:render()
    return StudioTheme.use(function(theme: StudioTheme)
        return e("Frame", {
            BackgroundColor3 = theme:GetColor("MainBackground"),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ClipsDescendants = true,
        }, {
            navbar = e(FluidFrame, {
                fixedSide = "end",
                fixedSize = 36,

                fixedItems = {
                    settings = e(TabBar.Button, {
                        icon = "Settings",
                    }),
                },
            }, {
                tabs = e(TabBar.Bar, nil, {
                    search = e(TabBar.Button, {
                        label = "Search",
                        icon = "Search",
                        active = true,
                        order = 10,
                    }),
                    palettes = e(TabBar.Button, {
                        label = "Palettes",
                        icon = "Palette",
                        order = 20,
                    }),
                })
            }),
        })
    end)
end

return Component
