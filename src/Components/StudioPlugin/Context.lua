local Root = script.Parent.Parent.Parent

local CreateContext = require(Root.Util.Context)

return {
    Plugin = CreateContext(),
    Toolbar = CreateContext(),
    Widget = CreateContext(),
}
