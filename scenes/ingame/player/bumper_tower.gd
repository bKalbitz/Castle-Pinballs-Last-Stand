extends EnemyBlockingArea2D

const BALL_LAUNCH_SPEED = 2500
const SHOOT_PARTICLE_Y_OFFSET = -60
var TowerShootingParticles = preload("res://scenes/ingame/player/tower_shooting_particles.tscn")
var shootTargetCount = 1
var shootReady = false
var damage = 1
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUpgradeUtils.connect("upgradeLoaded", Callable(self, "_on_upgradeLoaded"))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shootReady:
		var areas = $ShootingArea.get_overlapping_areas()
		var count = 0
		for area in areas:
			if area.has_method("applyDamage") && area.get("entityType") == "enemy" && not area.get("dead"):
				shootReady = false
				var particles = TowerShootingParticles.instantiate()
				add_child(particles)
				particles.position = Vector2(0, SHOOT_PARTICLE_Y_OFFSET)
				particles.fire(position.direction_to(area.position))
				area.applyDamage(damage, "basic")
				count = count + 1
			if count >= shootTargetCount:
				break


func _on_body_entered(body: Node2D) -> void:
	if body.has_method("launch"):
		var vector = position.direction_to(body.position)
		body.launch(Vector2(vector.x * BALL_LAUNCH_SPEED, vector.y * BALL_LAUNCH_SPEED))

func _on_upgradeLoaded(icon: UpgradeIcon) -> void:
	if PlayerUpgradeUtils.UpgradeType.BUMPER_SHOOT == icon.upgrade:
		icon.startTimer()
		shootTargetCount = icon.level
		shootReady = true
