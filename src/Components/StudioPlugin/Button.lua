local Root = script.Parent.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)
local Llama = require(Root.Packages.Llama)

local Context = require(script.Parent.Context)

local e = Roact.createElement

local Component: RoactComponent = Roact.Component:extend("PluginToolbarButton")

Component.defaultProps = {
    toolbar = nil,

    id = nil,
    tooltip = nil,
    icon = nil,
    label = nil,
    alwaysAvailable = true,

    enabled = true,
    active = false,

    onClick = nil,
}

function Component:init()
    local toolbar: PluginToolbar = self.props.toolbar

    self.button = toolbar:CreateButton(
        self.props.id,
        self.props.tooltip,
        self.props.icon,
        self.props.label
    )

    self.button.ClickableWhenViewportHidden = self.props.alwaysAvailable

    self.button.Click:Connect(function()
        if type(self.props.onClick) == "function" then
            self.props.onClick()
        end
    end)
end

function Component:willUnmount()
    self.button:Destroy()
end

function Component:didUpdate(prevProps)
    if prevProps.enabled ~= self.props.enabled then
        self.button.Enabled = self.props.enabled
    end

    if prevProps.active ~= self.props.active then
        self.button:SetActive(self.props.active)
    end
end

function Component:render()
    return nil
end

function Component.wrap(props)
    return e(Context.Toolbar.Consumer, {
        render = function(toolbar: PluginToolbar)
            return e(Component, Llama.Dictionary.merge(props, {
                toolbar = toolbar,
            }))
        end
    })
end

return Component.wrap
