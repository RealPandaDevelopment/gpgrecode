local Utilities = {}

-- Number formatting
function Utilities.FormatNumber(number: number): string
	if number >= 1e12 then
		return string.format("%.2fT", number / 1e12)
	elseif number >= 1e9 then
		return string.format("%.2fB", number / 1e9)
	elseif number >= 1e6 then
		return string.format("%.2fM", number / 1e6)
	elseif number >= 1e3 then
		return string.format("%.2fK", number / 1e3)
	else
		return tostring(math.floor(number))
	end
end

-- Table utilities
function Utilities.DeepCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		if type(value) == "table" then
			copy[key] = Utilities.DeepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end

-- Math utilities
function Utilities.Lerp(start: number, finish: number, alpha: number): number
	return start + (finish - start) * alpha
end

function Utilities.Clamp(value: number, min: number, max: number): number
	return math.max(min, math.min(max, value))
end

-- Experience calculation
function Utilities.CalculateExperienceRequired(level: number): number
	local GameConstants = require(script.Parent.Parent.constants.GameConstants)
	return math.floor(
		GameConstants.EXPERIENCE.BASE_REQUIREMENT * (GameConstants.EXPERIENCE.SCALING_FACTOR ^ (level - 1))
	)
end

-- Level from experience
function Utilities.GetLevelFromExperience(experience: number): number
	local level = 1
	local totalRequired = 0

	while totalRequired <= experience do
		totalRequired += Utilities.CalculateExperienceRequired(level)
		if totalRequired <= experience then
			level += 1
		end
	end

	return level - 1
end

return Utilities
