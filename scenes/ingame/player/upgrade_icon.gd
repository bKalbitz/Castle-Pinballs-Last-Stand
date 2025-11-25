class_name UpgradeIcon extends TextureRect

signal upgradeLoaded
var upgrade: PlayerUpgradeUtils.UpgradeType
var loadTime: float
var level: int
var icon: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	if loadTime > 0.0:
		$VBox/TimerProgressBar.max_value = loadTime
		$VBox/TimerProgressBar.value = loadTime - $Timer.time_left

func _on_timer_timeout() -> void:
	upgradeLoaded.emit(self)

func setData(_upgrade: PlayerUpgradeUtils.UpgradeType, _loadTime: float, _level: int, _icon: String) -> void:
	upgrade = _upgrade
	loadTime = _loadTime
	if loadTime > 0.0:
		$VBox/TimerProgressBar.show()
		$Timer.wait_time = loadTime
	else:
		$VBox/TimerProgressBar.hide()
	level = _level
	$VBox/Label.text = str(level)
	icon = _icon
	texture = load(icon)

func startTimer() -> void:
	if $Timer.is_stopped():
		$Timer.start()
