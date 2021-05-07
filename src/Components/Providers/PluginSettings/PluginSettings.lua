local Defaults = require(script.Parent.Defaults)

local PluginSettings = {}

PluginSettings.__index = PluginSettings
PluginSettings._globalChangeEvent = Instance.new("BindableEvent")
PluginSettings.Changed = PluginSettings._globalChangeEvent.Event

local SUB_PATTERN = "[^A-Za-z0-0-_]"

local gsub = string.gsub

function PluginSettings.new(plugin: Plugin)
    local self = setmetatable({}, PluginSettings)

    self.plugin = plugin

    self._changeListeners = {}
    self._globalListener = self.Changed:Connect(function(key: string, value: any)
        for signalKey, signalEvent in pairs(self._changeListeners) do
            if signalKey == key then
                signalEvent:Fire(value)
                break
            end
        end
    end)

    return self
end

function PluginSettings:_formatKey(key: string): string
    local subKey = gsub(key, SUB_PATTERN, "")
    return subKey
end

function PluginSettings:Set(key: string, value: any)
    local fmtKey = self:_formatKey(key)

    self._plugin:SetSetting(fmtKey, value)
    self._globalChangeEvent:Fire(key, value)
end

function PluginSettings:Get(key: string): any
    local fmtKey = self:_formatKey(key)
    local savedValue = self._plugin:GetSetting(fmtKey)

    if type(savedValue) == "nil" then
        return Defaults[key]
    end

    return savedValue
end

function PluginSettings:Reset(key: string?)
    if type(key) == "nil" then
        for defaultKey, defaultValue in pairs(Defaults) do
            self:Set(defaultKey, defaultValue)
        end

        return
    end

    self:Set(key, Defaults[key])
end

function PluginSettings:GetChangedSignal(key: string): RBXScriptSignal
    local signal = self._changeListeners[key]

    if signal == nil then
        signal = Instance.new("BindableEvent")
        self._changeListeners[key] = signal
    end

    return signal.Event
end

function PluginSettings:Destroy()
    self._globalListener:Disconnect()

    for _, signal in pairs(self._changeListeners) do
        signal:Destroy()
    end

    for key, _ in pairs(self) do
        self[key] = nil
    end
end

return PluginSettings
