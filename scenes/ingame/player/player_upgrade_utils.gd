extends Node

signal upgradeLoaded
signal upgraded

enum UpgradeType {
	#FLIPPER_BLAST, 
	#FLIPPER_SHOT,
	#FlIPPER_DAMAGE,
	BALL_MINE,
	BALL_SPAWN,
	BALL_EXPLODE,
	BALL_SLOW_DOWN,
	BUMPER_SHOOT,
	BUMPER_SET_BALL_ON_FIRE,
	#BUMPER_RANDOM_METEOR,
	REPAIR}

var upgrades = {}

var data = loadData()

var ingameHud: IngameHud
var levelUpHud: LevelUpHud

func reset() -> void:
	for upgrade in PlayerUpgradeUtils.UpgradeType.values():
		upgrades[upgrade] = 0

func randomUpgrades(size: int) -> Array[UpgradeType]:
	var result: Array[UpgradeType] = []
	var from: Array[UpgradeType] = []
	for upgrade in UpgradeType.values():
		if upgrades[upgrade] < 3:
			from.append(upgrade)
	
	for i in size:
		if from.size() > 0:
			result.append(from.pop_at(randi()%from.size()))
	return result

func getUpgradeConfig(upgrade: UpgradeType) -> Dictionary:
	var key = UpgradeType.keys()[upgrade]
	return data[key]

func getUpgradeTitle(upgrade: UpgradeType) -> String:
	var title = getUpgradeConfig(upgrade)["title"]
	return title

func getUpgradeIcon(upgrade: UpgradeType) -> String:
	var icon = getUpgradeConfig(upgrade)["icon"]
	return icon

func getUpgrateDesciption(upgrade: UpgradeType) -> String:
	var upgradeLevel = getUpgradeConfig(upgrade)["levels"][upgrades[upgrade]]
	var text = upgradeLevel["text"]
	return text

func loadData() -> Dictionary:
	var jsonString = FileAccess.get_file_as_string("res://data/upgrade_config.json")
	return JSON.parse_string(jsonString)

func registerHud(_ingameHud: IngameHud, _levelUpHud:LevelUpHud) -> void:
	ingameHud = _ingameHud
	levelUpHud = _levelUpHud
	levelUpHud.connect("upgrade_selected", Callable(self, "_on_level_up_hud_upgrade_selected"))
	
func _on_level_up_hud_upgrade_selected(upgrade: PlayerUpgradeUtils.UpgradeType) -> void:
	var level: int = upgrades[upgrade]
	var upgradeConfig = getUpgradeConfig(upgrade)
	var upgradeLevel = upgradeConfig["levels"][level]
	level = level + 1
	upgrades[upgrade] = level
	var icon = ingameHud.getUpgradeIcon(upgrade)
	if not icon:
		icon = ingameHud.createUpgradeIcon(upgrade, upgradeLevel["timeout"], level, upgradeConfig["icon"])
		icon.connect("upgradeLoaded", Callable(self, "_on_upgrade_icon_upgradeLoaded"))
	icon.setData(upgrade, upgradeLevel["timeout"], level, upgradeConfig["icon"])
	icon.startTimer()
	upgraded.emit(upgrade)
	
func _on_upgrade_icon_upgradeLoaded(icon: UpgradeIcon) -> void:
	upgradeLoaded.emit(icon)
