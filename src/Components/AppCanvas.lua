local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local RoactRouter = require(PluginRoot.Packages.RoactRouter)

local Styles = require(Components.Styles)
local Pages = require(Components.Pages)
local Routing = require(Components.Routing)

local e = Roact.createElement

local Component = Roact.Component:extend("AppCanvas")

function Component:render()
    return Styles.StudioTheme.use(function(theme: StudioTheme)
        return e("Frame", {
            BackgroundColor3 = theme:GetColor("MainBackground"),
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
        }, {
            appContainer = e(Styles.FlexFrame, {
                direction = "y",

                fixedItems = {
                    -- TODO: Implement update banner
                    updateBanner = nil,
                },
            }, {
                router = e(RoactRouter.Router, nil, {
                    bodyContainer = e(Styles.FlexFrame, {
                        direction = "y",
                        fixedSize = 36,

                        fixedItems = {
                            navbar = e(Routing.Navbar),
                        },
                    }, {
                        search = e(Pages.Search),
                        -- palettes = e(Pages.Palettes),
                        -- settings = e(Pages.Settings),
                    }),
                }),
            }),
        })
    end)
end

return Component
