class_name IngameHud extends Panel

var UpgradeIconScene = preload("res://scenes/ingame/player/upgrade_icon.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func setWidth(newWidth: float) -> void:
	size.x = newWidth
	$VFlowContainer.size.x = newWidth
	$VFlowContainer/Score.size.x = newWidth
	$VFlowContainer/Score.custom_minimum_size.x = newWidth
	$VFlowContainer/Health.size.x = newWidth
	$VFlowContainer/Health.custom_minimum_size.x = newWidth
	$VFlowContainer/Experience.size.x = newWidth
	$VFlowContainer/Experience.custom_minimum_size.x = newWidth

func setPosition(newPosition: Vector2) -> void:
	position = newPosition

func setScore(score:int) -> void:
	$VFlowContainer/Score.text = str(score)

func setHealth(current: float, max: float) -> void:
	$VFlowContainer/Health.max_value = max
	$VFlowContainer/Health.value = current

func setXp(current: float, max: float) -> void:
	$VFlowContainer/Experience.max_value = max
	$VFlowContainer/Experience.value = current

func getUpgradeIcon(upgrade: PlayerUpgradeUtils.UpgradeType) -> UpgradeIcon:
	for node in $VFlowContainer/Upgrades.get_children():
		if upgrade == node.upgrade:
			return node
	return null 

func createUpgradeIcon(_upgrade: PlayerUpgradeUtils.UpgradeType, _loadTime: float, _level: int, _icon: String) -> UpgradeIcon:
	var icon = UpgradeIconScene.instantiate()
	icon.setData(_upgrade, _loadTime, _level, _icon)
	$VFlowContainer/Upgrades.add_child(icon)
	return icon

func clearUpgrades() -> void:
	for node in $VFlowContainer/Upgrades.get_children():
		$VFlowContainer/Upgrades.remove_child(node)
		node.queue_free()
	
