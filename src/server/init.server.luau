-- This is a script you would create in ServerScriptService, for example.
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Cmdr = require(script.Parent.Cmdr)

Cmdr:RegisterDefaultCommands()
Cmdr:RegisterHooksIn(script.Parent.Cmdr.Hooks)
