--[[
    Custom Signal implementation for event handling
]]
--

local Signal = {}
Signal.__index = Signal

function Signal.new()
	local self = setmetatable({}, Signal)
	self._connections = {}
	return self
end

function Signal:Connect(callback)
	local connection = {
		callback = callback,
		connected = true,
	}

	table.insert(self._connections, connection)

	return {
		Disconnect = function()
			connection.connected = false
			for i, conn in ipairs(self._connections) do
				if conn == connection then
					table.remove(self._connections, i)
					break
				end
			end
		end,
	}
end

function Signal:Fire(...)
	for _, connection in ipairs(self._connections) do
		if connection.connected then
			task.spawn(connection.callback, ...)
		end
	end
end

function Signal:Destroy()
	for _, connection in ipairs(self._connections) do
		connection.connected = false
	end
	self._connections = {}
end

return Signal
