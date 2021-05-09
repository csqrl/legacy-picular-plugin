local PluginRoot = script:FindFirstAncestor("PicularPlugin")
local Components = PluginRoot.Components

local Roact: Roact = require(PluginRoot.Packages.Roact)
local RoactRouter = require(PluginRoot.Packages.RoactRouter)

local Styles = require(Components.Styles)
local Content = require(Components.Content)
local Controls = require(Components.Controls)
local Bespoke = require(Components.Bespoke)

local e = Roact.createElement

local Component = Roact.PureComponent:extend("SettingsPage")

function Component:render()
    return e(RoactRouter.Route, {
        path = "/settings",
        render = function()
            return Styles.StudioTheme.use(function(theme: StudioTheme, styles)
                return e(Content.ScrollFrame, nil, {
                    padding = e(Styles.UIPadding),

                    patronBanner = e(Bespoke.PatronBanner),
                })
            end)
        end,
    })
end

return Component
