local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RemoteNames = require(ReplicatedStorage.Shared.constants.RemoteNames)

local RemoteService = {}

-- Storage for remotes
local remotes = {}

-- Create a RemoteEvent
function RemoteService.CreateRemoteEvent(name: string): RemoteEvent
	local remote = Instance.new("RemoteEvent")
	remote.Name = name
	remote.Parent = ReplicatedStorage.Remotes

	remotes[name] = remote
	return remote
end

-- Create a RemoteFunction
function RemoteService.CreateRemoteFunction(name: string): RemoteFunction
	local remote = Instance.new("RemoteFunction")
	remote.Name = name
	remote.Parent = ReplicatedStorage.Remotes

	remotes[name] = remote
	return remote
end

-- Get existing remote
function RemoteService.GetRemote(name: string): RemoteEvent | RemoteFunction
	return remotes[name] or ReplicatedStorage.Remotes:FindFirstChild(name)
end

-- Initialize all remotes
function RemoteService.Initialize()
	-- Create all remotes based on RemoteNames
	for _, remoteName in pairs(RemoteNames) do
		if not remotes[remoteName] then
			RemoteService.CreateRemoteEvent(remoteName)
		end
	end

	print("RemoteService initialized with", #remotes, "remotes")
end

return RemoteService
