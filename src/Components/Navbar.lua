local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local JustifyFrame = require(Components.JustifyFrame)
local FluidFrame = require(Components.FluidFrame)
local TabButton = require(Components.TabButton)

local bind = require(Root.Util.Bind)
local e = Roact.createElement

local Component: RoactComponent = Roact.PureComponent:extend("NavigationBar")

function Component:render()
    return e(RoactRouter.Watcher, {
        render = function(routing)
            local path = routing.location.path

            return e("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 36),
                ClipsDescendants = true,
            }, {
                container = e(FluidFrame, {
                    fixedSide = "end",
                    fixedSize = 36,

                    fixedItems = {
                        settings = e(TabButton, {
                            icon = "Settings",

                            active = path == "/settings",
                            onClick = bind(routing.history.replace, routing.history, "/settings"),
                        }),
                    },
                }, {
                    tabs = e(JustifyFrame, nil, {
                        search = e(TabButton, {
                            label = "Search",
                            icon = "Search",
                            order = 10,

                            active = path == "/",
                            onClick = bind(routing.history.replace, routing.history, "/"),
                        }),

                        palettes = e(TabButton, {
                            label = "Palettes",
                            icon = "Palette",
                            order = 20,

                            active = path == "/palettes",
                            onClick = bind(routing.history.replace, routing.history, "/palettes"),
                        }),
                    })
                }),
            })
        end,
    })
end

return Component
