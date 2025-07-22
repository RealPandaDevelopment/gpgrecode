local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local DataService = require(script.Parent.DataService)
local RemoteService = require(script.Parent.RemoteService)
local GameConstants = require(ReplicatedStorage.Shared.constants.GameConstants)
local RemoteNames = require(ReplicatedStorage.Shared.constants.RemoteNames)
local Utilities = require(ReplicatedStorage.Shared.modules.Utilities)

local PlayerService = {}

-- Initialize player when they join
function PlayerService.PlayerAdded(player: Player)
	print(player.Name .. " joined the game")

	-- Load their data
	DataService.LoadPlayerData(player)

	-- Send data to client when loaded
	DataService.PlayerDataLoaded:Connect(function(loadedPlayer, data)
		if loadedPlayer == player then
			local remote = RemoteService.GetRemote(RemoteNames.PLAYER_DATA_LOADED)
			remote:FireClient(player, data)
		end
	end)
end

-- Handle player leaving
function PlayerService.PlayerRemoving(player: Player)
	print(player.Name .. " left the game")
	DataService.PlayerRemoving(player)
end

-- Give experience to player
function PlayerService.GiveExperience(player: Player, amount: number)
	local data = DataService.GetPlayerData(player)
	if not data then
		return
	end

	data.experience += amount
	local newLevel = Utilities.GetLevelFromExperience(data.experience)

	-- Check for level up
	if newLevel > data.level then
		data.level = newLevel

		-- Fire level up event
		local levelUpRemote = RemoteService.GetRemote(RemoteNames.LEVEL_UP)
		levelUpRemote:FireClient(player, newLevel)
	end

	DataService.UpdatePlayerData(player, data)

	-- Notify client of experience gain
	local expRemote = RemoteService.GetRemote(RemoteNames.GAIN_EXPERIENCE)
	expRemote:FireClient(player, amount, data.experience, data.level)
end

-- Handle currency spending
function PlayerService.SpendCurrency(player: Player, amount: number): boolean
	local data = DataService.GetPlayerData(player)
	if not data then
		return false
	end

	if data.currency >= amount then
		data.currency -= amount
		DataService.UpdatePlayerData(player, data)

		-- Notify client
		local currencyRemote = RemoteService.GetRemote(RemoteNames.CURRENCY_CHANGED)
		currencyRemote:FireClient(player, data.currency)

		return true
	end

	return false
end

-- Give currency to player
function PlayerService.GiveCurrency(player: Player, amount: number)
	local data = DataService.GetPlayerData(player)
	if not data then
		return
	end

	data.currency += amount
	data.currency = math.min(data.currency, GameConstants.CURRENCY.MAX_AMOUNT)

	DataService.UpdatePlayerData(player, data)

	-- Notify client
	local currencyRemote = RemoteService.GetRemote(RemoteNames.CURRENCY_CHANGED)
	currencyRemote:FireClient(player, data.currency)
end

-- Setup remote connections
function PlayerService.SetupRemotes()
	local spendRemote = RemoteService.GetRemote(RemoteNames.SPEND_CURRENCY)
	spendRemote.OnServerEvent:Connect(function(player, amount)
		PlayerService.SpendCurrency(player, amount)
	end)

	local saveRemote = RemoteService.GetRemote(RemoteNames.REQUEST_SAVE)
	saveRemote.OnServerEvent:Connect(function(player)
		DataService.SavePlayerData(player)
	end)
end

return PlayerService
