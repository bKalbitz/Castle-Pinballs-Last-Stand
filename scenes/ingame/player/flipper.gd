class_name Flipper extends RigidBody2D

const INFANTERY_SPACING = 64
const ROOTATION_SPEED = -25
const RIGHT_TOP_RAD = -135
const LEFT_TOP_RAD = -45
const RIGHT_BOTTOM_RAD = -192
const LEFT_BOTTOM_RAD = 12

const Infantery = preload("res://scenes/ingame/player/infantery.tscn")

var pressed = false
var damage = 1
@export var right_side = false
@export var input_key = "flipper_left"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUpgradeUtils.connect("upgradeLoaded", Callable(self, "_on_upgradeLoaded"))
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed(input_key):
		if right_side:
			if rotation < deg_to_rad(RIGHT_TOP_RAD):
				rotate(ROOTATION_SPEED * delta * -1)
		else:
			if rotation > deg_to_rad(LEFT_TOP_RAD):
				rotate(ROOTATION_SPEED * delta)
		if not pressed:
			pressed = true
			hitEnemies()
			if not $FlipperSound.playing:
				$FlipperSound.play()
	else:
		pressed = false
		if right_side:
			if rotation > deg_to_rad(RIGHT_BOTTOM_RAD):
				rotate(ROOTATION_SPEED * delta)
		else:
			if rotation < deg_to_rad(LEFT_BOTTOM_RAD):
				rotate(ROOTATION_SPEED * delta * -1)

func hitEnemies() -> void:
	var areas = $HitArea.get_overlapping_areas()
	for area in areas:
		if area.has_method("applyDamage"):
			area.applyDamage(damage, "basic")

func _on_upgradeLoaded(icon: UpgradeIcon) -> void:
	if PlayerUpgradeUtils.UpgradeType.CHARGE == icon.upgrade:
		var count = PlayerUpgradeUtils.upgrades[PlayerUpgradeUtils.UpgradeType.CHARGE]
		for i in count:
			var infantery = Infantery.instantiate();
			infantery.position = Vector2(position.x + INFANTERY_SPACING * i * (-1 if right_side else 1), position.y)
			get_parent().add_child(infantery)
		icon.startTimer()
	pass
