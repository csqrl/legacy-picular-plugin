local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local RoactRouter = require(PluginRoot.Packages.RoactRouter)

local Styles = require(Components.Styles)
local TabButton = require(script.Parent.TabButton)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("NavigationTabStrip")

function Component:init()
    self.navigateTo = function(routing, path: string)
        return function()
            routing.history:replace(path)
        end
    end
end

function Component:render()
    return e(RoactRouter.Watcher, {
        render = function(routing)
            local path = routing.location.path

            return e(Styles.FlexFrame, {
                direction = "x",
                fixedSize = 36,
                fixedSide = "end",

                fixedItems = {
                    settingsLink = e(TabButton, {
                        active = path == "/settings",
                        onClick = self.navigateTo(routing, "/settings"),
                        icon = "Settings",
                    }),
                },
            }, {
                tabButtonContainer = e(Styles.JustifyFrame, {
                    direction = "x",
                }, {
                    searchLink = e(TabButton, {
                        order = 10,
                        active = path == "/",
                        onClick = self.navigateTo(routing, "/"),
                        label = "Search",
                        icon = "Search",
                    }),

                    palettesLink = e(TabButton, {
                        order = 20,
                        active = path == "/palettes",
                        onClick = self.navigateTo(routing, "/palettes"),
                        label = "Palettes",
                        icon = "Palette",
                    }),
                }),
            })
        end
    })
end

return Component
