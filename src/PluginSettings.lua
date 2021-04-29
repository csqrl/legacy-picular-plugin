local plugin = script:FindFirstAncestorOfClass("Plugin")
local Root = script.Parent

local Config = require(Root.Data.Config)
local keyPrefix = Config.Storage

local DEFAULT_SETTINGS = {
    colourCodes = "RGB",
    devLogging = false,
    autoCheckUpdates = true,
}

local PluginSettings = {}

PluginSettings._event = Instance.new("BindableEvent")
PluginSettings.Changed = PluginSettings._event.Event

local function FormatKey(key: string): string
    return string.format("%s_settings_%s", keyPrefix, key)
end

local function ValidateKey(key: string)
    if type(DEFAULT_SETTINGS[key]) == "nil" then
        error(string.format("%q is not a valid PluginSettings key", tostring(key)), 3)
    end
end

function PluginSettings.Get(key: string): any
    ValidateKey(key)

    local persistKey = FormatKey(key)
    local persistValue = plugin:GetSetting(persistKey)

    if persistValue == nil then
        return DEFAULT_SETTINGS[key]
    end

    return persistValue
end

function PluginSettings.Set(key: string, value: any)
    ValidateKey(key)

    local persistKey = FormatKey(key)

    plugin:SetSetting(persistKey, value)

    PluginSettings._event:Fire(key, value)
end

function PluginSettings.Reset(key: string)
    return PluginSettings.Set(key, DEFAULT_SETTINGS[key])
end

return PluginSettings
