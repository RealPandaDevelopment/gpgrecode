local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local RemoteNames = require(ReplicatedStorage.Shared.constants.RemoteNames)
local Signal = require(ReplicatedStorage.Shared.modules.Signal)

local PlayerController = {}

-- Events
PlayerController.DataLoaded = Signal.new()
PlayerController.ExperienceChanged = Signal.new()
PlayerController.LevelChanged = Signal.new()
PlayerController.CurrencyChanged = Signal.new()

-- Private
local player = Players.LocalPlayer
local playerData = nil

-- Get current player data
function PlayerController.GetPlayerData()
	return playerData
end

-- Request save from server
function PlayerController.RequestSave()
	local remote = ReplicatedStorage.Remotes:WaitForChild(RemoteNames.REQUEST_SAVE)
	remote:FireServer()
end

-- Setup remote connections
function PlayerController.Initialize()
	-- Player data loaded
	local dataLoadedRemote = ReplicatedStorage.Remotes:WaitForChild(RemoteNames.PLAYER_DATA_LOADED)
	dataLoadedRemote.OnClientEvent:Connect(function(data)
		playerData = data
		PlayerController.DataLoaded:Fire(data)
		print("Player data loaded:", data)
	end)

	-- Experience gained
	local expRemote = ReplicatedStorage.Remotes:WaitForChild(RemoteNames.GAIN_EXPERIENCE)
	expRemote.OnClientEvent:Connect(function(amount, totalExp, level)
		if playerData then
			playerData.experience = totalExp
			playerData.level = level
		end
		PlayerController.ExperienceChanged:Fire(amount, totalExp, level)
	end)

	-- Level up
	local levelUpRemote = ReplicatedStorage.Remotes:WaitForChild(RemoteNames.LEVEL_UP)
	levelUpRemote.OnClientEvent:Connect(function(newLevel)
		PlayerController.LevelChanged:Fire(newLevel)
		print("Level up! New level:", newLevel)
	end)

	-- Currency changed
	local currencyRemote = ReplicatedStorage.Remotes:WaitForChild(RemoteNames.CURRENCY_CHANGED)
	currencyRemote.OnClientEvent:Connect(function(newAmount)
		if playerData then
			playerData.currency = newAmount
		end
		PlayerController.CurrencyChanged:Fire(newAmount)
	end)

	print("PlayerController initialized")
end

return PlayerController
