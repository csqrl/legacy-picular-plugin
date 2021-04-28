local Root = script.Parent.Parent
local Components = Root.Components

local Roact: Roact = require(Root.Packages.Roact)
local RoactRouter = require(Root.Packages.RoactRouter)

local StudioTheme = require(Components.StudioTheme)
local Navbar = require(Components.Navbar)
local Pages = require(Components.Pages)

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
            router = e(RoactRouter.Router, nil, {
                navbar = e(Navbar),

                content = e("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(0, 36),
                    Size = UDim2.new(1, 0, 1, -36),
                    ClipsDescendants = true,
                }, {
                    -- TODO: Pages
                    settings = e(Pages.Settings),
                }),
            }),
        })
    end)
end

return Component
