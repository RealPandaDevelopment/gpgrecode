local GameConstants = {}

-- Experience and Leveling
GameConstants.EXPERIENCE = {
	BASE_REQUIREMENT = 100,
	SCALING_FACTOR = 1.5,
	MAX_LEVEL = 1000,
}

-- Currency
GameConstants.CURRENCY = {
	STARTING_AMOUNT = 0,
	MAX_AMOUNT = math.huge,
}

-- Data Management
GameConstants.DATA = {
	AUTO_SAVE_INTERVAL = 60, -- seconds
	SESSION_TIMEOUT = 300, -- 5 minutes
	MAX_RETRIES = 3,
}

-- UI
GameConstants.UI = {
	TWEEN_TIME = 0.3,
	NOTIFICATION_DURATION = 3,
}

return GameConstants
