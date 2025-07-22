export type PlayerData = {
	userId: number,
	level: number,
	experience: number,
	currency: number,
	lastLogin: number,
	settings: PlayerSettings,
}

export type PlayerSettings = {
	musicEnabled: boolean,
	soundEnabled: boolean,
	autoSave: boolean,
}

export type StatData = {
	baseValue: number,
	multiplier: number,
	bonuses: { number },
}

return {}
