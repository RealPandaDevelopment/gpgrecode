local Players = game:GetService("Players")
local DataStoreService = game:GetService("DataStoreService")
local RunService = game:GetService("RunService")

local Signal = require(game.ReplicatedStorage.Shared.modules.Signal)
local PlayerTypes = require(game.ReplicatedStorage.Shared.types.PlayerTypes)
local GameConstants = require(game.ReplicatedStorage.Shared.constants.GameConstants)

local DataService = {}
DataService.PlayerDataLoaded = Signal.new()
DataService.PlayerDataChanged = Signal.new()

-- Private
local playerDataStore = DataStoreService:GetDataStore("PlayerData_v1")
local playerData = {}
local autoSaveConnection

-- Default player data
local function getDefaultData(): PlayerTypes.PlayerData
	return {
		userId = 0,
		level = 1,
		experience = 0,
		currency = GameConstants.CURRENCY.STARTING_AMOUNT,
		lastLogin = os.time(),
		settings = {
			musicEnabled = true,
			soundEnabled = true,
			autoSave = true,
		},
	}
end

-- Load player data
function DataService.LoadPlayerData(player: Player)
	local success, data = pcall(function()
		return playerDataStore:GetAsync(player.UserId)
	end)

	if success and data then
		playerData[player.UserId] = data
		playerData[player.UserId].lastLogin = os.time()
	else
		warn("Failed to load data for " .. player.Name .. ", using defaults")
		playerData[player.UserId] = getDefaultData()
		playerData[player.UserId].userId = player.UserId
	end

	DataService.PlayerDataLoaded:Fire(player, playerData[player.UserId])
end

-- Save player data
function DataService.SavePlayerData(player: Player)
	if not playerData[player.UserId] then
		return
	end

	local success, errorMessage = pcall(function()
		playerDataStore:SetAsync(player.UserId, playerData[player.UserId])
	end)

	if not success then
		warn("Failed to save data for " .. player.Name .. ": " .. errorMessage)
	end
end

-- Get player data
function DataService.GetPlayerData(player: Player): PlayerTypes.PlayerData?
	return playerData[player.UserId]
end

-- Update player data
function DataService.UpdatePlayerData(player: Player, newData: PlayerTypes.PlayerData)
	if playerData[player.UserId] then
		playerData[player.UserId] = newData
		DataService.PlayerDataChanged:Fire(player, newData)
	end
end

-- Cleanup on player leaving
function DataService.PlayerRemoving(player: Player)
	DataService.SavePlayerData(player)
	playerData[player.UserId] = nil
end

-- Auto-save setup
function DataService.StartAutoSave()
	autoSaveConnection = task.spawn(function()
		while true do
			task.wait(GameConstants.DATA.AUTO_SAVE_INTERVAL)

			for _, player in ipairs(Players:GetPlayers()) do
				DataService.SavePlayerData(player)
			end
		end
	end)
end

function DataService.StopAutoSave()
	if autoSaveConnection then
		task.cancel(autoSaveConnection)
		autoSaveConnection = nil
	end
end

return DataService
