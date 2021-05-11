local PluginRoot = script:FindFirstAncestor("PicularPlugin")

local Roact: Roact = require(PluginRoot.Packages.Roact)
local Llama = require(PluginRoot.Packages.Llama)

local ButtonBase = {}

function ButtonBase.init(self: RoactComponent)
    self:setState({
        hover = false,
        press = false,
    })

    self._onClick = function(originalCallback)
        return function(rbx: Instance, ...)
            if self.props.disabled then
                return
            end

            if type(self.onClick) == "function" then
                local result = self.onClick(rbx, ...)

                if result == false then
                    return
                end
            end

            if type(originalCallback) == "function" then
                originalCallback(rbx, ...)
            end

            if type(self.props.onClick) == "function" then
                self.props.onClick(rbx, ...)
            end
        end
    end

    self._onInputBegan = function(originalCallback)
        return function(rbx: Instance, input: InputObject, ...)
            if self.props.disabled then
                return
            end

            if type(self.onInputBegan) == "function" then
                self.onInputBegan(rbx, input, ...)
            end

            if type(originalCallback) == "function" then
                originalCallback(rbx, input, ...)
            end

            if input.UserInputType.Name:match("MouseButton%d+") or input.UserInputType == Enum.UserInputType.Touch then
                self:setState({ press = true })
            elseif input.UserInputType == Enum.UserInputType.MouseMovement then
                self:setState({ hover = true })
            end
        end
    end

    self._onInputEnded = function(originalCallback)
        return function(rbx: Instance, input: InputObject, ...)
            if type(self.onInputEnded) == "function" then
                self.onInputEnded(rbx, input, ...)
            end

            if type(originalCallback) == "function" then
                originalCallback(rbx, input, ...)
            end

            if input.UserInputType.Name:match("MouseButton%d+") or input.UserInputType == Enum.UserInputType.Touch then
                self:setState({ press = false })
            elseif input.UserInputType == Enum.UserInputType.MouseMovement then
                self:setState({ hover = false, press = false })
            end
        end
    end
end

function ButtonBase.render(self: RoactComponent, element: RoactElement)
    return Roact.createElement(element.component, Llama.Dictionary.merge(element.props, {
        [Roact.Event.Activated] = self._onClick(element.props[Roact.Event.Activated]),
        [Roact.Event.InputBegan] = self._onInputBegan(element.props[Roact.Event.InputBegan]),
        [Roact.Event.InputEnded] = self._onInputEnded(element.props[Roact.Event.InputEnded]),
    }))
end

function ButtonBase.getModifier(
    self: RoactComponent
): (Enum.StudioStyleGuideModifier, Enum.StudioStyleGuideModifier)
    local modifier = Enum.StudioStyleGuideModifier.Default
    local secondaryModifier = Enum.StudioStyleGuideModifier.Default

    if self.props.disabled then
        modifier = Enum.StudioStyleGuideModifier.Disabled
    elseif self.props.active or self.state.active then
        modifier = Enum.StudioStyleGuideModifier.Selected
    elseif self.state.press then
        modifier = Enum.StudioStyleGuideModifier.Pressed
    elseif self.state.hover then
        modifier = Enum.StudioStyleGuideModifier.Hover
    end

    if modifier ~= Enum.StudioStyleGuideModifier.Selected then
        secondaryModifier = modifier
    end

    return modifier, secondaryModifier
end

return ButtonBase
