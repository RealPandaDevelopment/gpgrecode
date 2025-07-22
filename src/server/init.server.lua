print("Server starting...")

-- Roblox Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cmdr Setup (existing)
local Cmdr = require(script.Parent.Cmdr)
Cmdr:RegisterDefaultCommands()
Cmdr:RegisterHooksIn(script.Parent.Cmdr.Hooks)
print("Cmdr initialized")

-- Wait for shared modules to load
ReplicatedStorage:WaitForChild("Shared")
print("Shared modules loaded")

-- Our services (add debug prints here)
print("Attempting to require DataService...")
local DataService = require(script.Parent.Server.services.DataService)
print("DataService loaded!")

print("Attempting to require RemoteService...")
local RemoteService = require(script.Parent.Server.services.RemoteService)
print("RemoteService loaded!")

print("Attempting to require PlayerService...")
local PlayerService = require(script.Parent.Server.services.PlayerService)
print("PlayerService loaded!")

-- Connect player events
Players.PlayerAdded:Connect(PlayerService.PlayerAdded)
Players.PlayerRemoving:Connect(PlayerService.PlayerRemoving)

-- Handle players already in game (for testing)
for _, player in ipairs(Players:GetPlayers()) do
	PlayerService.PlayerAdded(player)
end

print("Server initialized successfully!")
