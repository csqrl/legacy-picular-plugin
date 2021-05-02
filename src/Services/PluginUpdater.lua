local InsertService = game:GetService("InsertService")
local RunService = game:GetService("RunService")

local PluginSettings = require(script.Parent.PluginSettings)
local Semver = require(script.Parent.Parent.Packages.Semver)
local Config = require(script.Parent.Parent.Config)

local plugin = script:FindFirstAncestorOfClass("Plugin")

local PostSimulation = RunService.PostSimulation

local Updater = {
    _cachedPlugin = nil,
    _lastCache = 0,
    _lastPoll = 0,

    CacheTimeout = 600,
    PollInterval = 300,

    _updateReadyEvent = Instance.new("BindableEvent"),
}

Updater.onUpdateReady = Updater._updateReadyEvent.Event

local function GetPluginId(): number
    return Config.Id
end

local function GetCurrentPluginVersion(): string
    return Config.Version
end

local function GetLatestPluginRelease(): Instance?
    local now = tick()

    if Updater._cachedPlugin and now - Updater._lastCache < Updater.CacheTimeout then
        return Updater._cachedPlugin
    end

    local pluginId = GetPluginId()
    local ok, pluginInstance = pcall(InsertService.LoadAsset, InsertService, pluginId)

    if not ok or not pluginInstance then
        return nil
    end

    local pluginSource = pluginInstance:GetChildren()[1]

    if not pluginSource then
        pluginInstance:Destroy()
        return nil
    end

    pluginSource.Parent = script
    pluginInstance:Destroy()

    Updater._lastCache = now
    Updater._cachedPlugin = pluginSource

    return pluginSource
end

local function GetLatestPluginVersion(): string?
    local latestRelease = GetLatestPluginRelease()
    local latestConfig = latestRelease:FindFirstChild("Config")

    if not latestConfig then
        return nil
    end

    -- selene: allow(shadowing)
    local ok, latestConfig = pcall(require, latestConfig)

    if not ok or not latestConfig then
        return nil
    end

    return latestConfig.Version
end

local function CanAutoCheckUpdates(): boolean
    return PluginSettings.Get("autoCheckUpdates")
end

local function IsUpdateAvailable(): (boolean?, string?)
    if not CanAutoCheckUpdates() then
        return false
    end

    local currentVersion = GetCurrentPluginVersion()
    local latestVersion = GetLatestPluginVersion()

    if not currentVersion or not latestVersion then
        return nil
    end

    return Semver.gt(latestVersion, currentVersion), latestVersion
end

local function PollForUpdates()
    local poller = nil

    local function _poll()
        local now = tick()

        if now - Updater._lastPoll < Updater.PollInterval then
            return
        end

        Updater._lastPoll = now

        local updateAvailable, newVersion = IsUpdateAvailable()

        if not updateAvailable then
            return nil
        end

        Updater._updateReadyEvent:Fire(newVersion)
        poller:Disconnect()
    end

    if CanAutoCheckUpdates() then
        poller = PostSimulation:Connect(_poll)
    end

    PluginSettings.Changed:Connect(function(key: string, value: any)
        if key ~= "autoCheckUpdates" then
            return nil
        end

        if value and not poller then
            poller = PostSimulation:Connect(_poll)
        elseif not value and poller then
            poller:Disconnect()
        end
    end)
end

function Updater.DisplayPluginManagementHelp()
    plugin:OpenWikiPage("articles/Intro-to-Plugins#finding-and-managing-plugins")
end

Updater.IsUpdateAvailable = IsUpdateAvailable

PollForUpdates()

return Updater
