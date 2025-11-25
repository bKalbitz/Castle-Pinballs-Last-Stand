class_name LevelUpHud extends Panel

signal upgrade_selected
var types = [PlayerUpgradeUtils.UpgradeType.REPAIR, PlayerUpgradeUtils.UpgradeType.REPAIR, PlayerUpgradeUtils.UpgradeType.REPAIR]
var texts = ["text1", "text2", "text3"]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

	
func showUprgradeOptions() -> void:
	var upgrades = PlayerUpgradeUtils.randomUpgrades(3)
	if upgrades.size() == 0:
		return
	
	if upgrades.size() > 0:
		setUpgrade($VBox/HBox/Upgrade1Button, upgrades, 0, true)
	
	if upgrades.size() > 1:
		setUpgrade($VBox/HBox/Upgrade2Button, upgrades, 1)
	else:
		$VBox/HBox/Upgrade2Button.hide()
		$VBox/HBox/Upgrade3Button.hide()
	
	if upgrades.size() > 2:
		setUpgrade($VBox/HBox/Upgrade3Button, upgrades, 2)
	else:
		$VBox/HBox/Upgrade3Button.hide()
	show()
	get_tree().paused = true

func setUpgrade(toButton: Button, upgrades:Array[PlayerUpgradeUtils.UpgradeType], index: int, focus = false) -> void:
	toButton.show()
	toButton.text = PlayerUpgradeUtils.getUpgradeTitle(upgrades[index])
	toButton.icon = load(PlayerUpgradeUtils.getUpgradeIcon(upgrades[index]))
	texts[index] = PlayerUpgradeUtils.getUpgrateDesciption(upgrades[index])
	types[index] = upgrades[index]
	if focus:
		toButton.grab_focus.call_deferred()

func _on_upgrade_button_pressed(index: int) -> void:
	upgrade_selected.emit(types[index])
	get_tree().paused = false
	hide()


func _on_upgrade_button_focus_entered(index: int) -> void:
	$VBox/DescriptionLabel.text = texts[index]
	
func setWidth(newWidth: float) -> void:
	size.x = newWidth
	$VBox.size.x = newWidth
