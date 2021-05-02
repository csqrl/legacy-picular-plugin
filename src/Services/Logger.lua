local plugin = script:FindFirstAncestorOfClass("Plugin")
local Config = require(script.Parent.Parent.Config)

local fmt = string.format

local Logger = {}

Logger.__index = Logger

function Logger.new(source: LuaSourceContainer)
    local self = setmetatable({}, Logger)

    self._source = source
    self._prefix = string.format("[%s]", source.Name)

    return self
end

function Logger:_canPrintToOutput(): boolean
    local setting = plugin:GetSetting(fmt("%s_settings_%s", Config.Storage, "devLogging"))

    if type(setting) ~= "boolean" then
        return false
    end

    return setting
end

function Logger:print(...)
    if not self:_canPrintToOutput() then
        return
    end

    print(self._prefix, ...)
end

function Logger:warn(...)
    if not self:_canPrintToOutput() then
        return
    end

    warn(self._prefix, ...)
end

function Logger:error(message: string, level: number?)
    local errorMessage = fmt("[%s] %s", message)

    if type(level) == "number" then
        level += 1
    end

    error(errorMessage, level or 3)
end

return Logger
