local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local RoactRouter = require(PluginRoot.Packages.RoactRouter)

local Styles = require(Components.Styles)
local Content = require(Components.Content)
local Controls = require(Components.Controls)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("SearchPage")

function Component:render()
    return e(RoactRouter.Route, {
        path = "/",
        exact = true,
        render = function()
            return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
                return e(Styles.FlexFrame, {
                    direction = "y",

                    fixedItems = {
                        searchContainer = e("Frame", {
                            Size = UDim2.new(1, 0, 0, 36 + styles.spacing * 2),
                            BackgroundColor3 = theme:GetColor("RibbonTab"),
                            BorderSizePixel = 0,
                        }, {
                            padding = e(Styles.UIPadding),

                            input = e(Controls.TextInput, {
                                placeholder = "Search for anything...",
                                iconId = "Search",
                                size = UDim2.new(1, 0, 0, 36),
                            }),
                        }),
                    },
                }, {
                    padding = e(Styles.UIPadding, { styles.spacing }),

                    contentContainer = e(Styles.FlexFrame, {
                        direction = "y",

                        fixedItems = {
                            smartfillBanner = e(Content.Paper, {
                                colour = theme:GetColor("Titlebar"),
                                size = UDim2.new(1, 0, 0, 36),
                            }),
                        },
                    }, {
                        content = e(Content.ScrollFrame, nil, {

                        }),
                    }),
                })
            end)
        end,
    })
end

return Component
