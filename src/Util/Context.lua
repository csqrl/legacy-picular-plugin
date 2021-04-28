local Root = script.Parent.Parent

local Roact: Roact = require(Root.Packages.Roact)

return function(defaultValue: any?): RoactContext
    return Roact.createContext(defaultValue)
end
