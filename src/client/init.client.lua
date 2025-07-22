print("Client starting...")

-- Roblox Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Cmdr Setup (existing)
local Cmdr = require(ReplicatedStorage:WaitForChild("CmdrClient"))
Cmdr:SetActivationKeys({ Enum.KeyCode.F2 })

-- Wait for shared modules to load
ReplicatedStorage:WaitForChild("Shared")
ReplicatedStorage:WaitForChild("Remotes")

-- Our controllers
local PlayerController = require(script.Parent.Client.controllers.PlayerController)

-- Initialize controllers
PlayerController.Initialize()

print("Client initialized successfully!")
