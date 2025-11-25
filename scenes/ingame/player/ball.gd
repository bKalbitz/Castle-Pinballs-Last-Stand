extends RigidBody2D

signal in_off
const BALL_SPAWN_LAUNCH_SPEED = 1000
const GlueSpot = preload("res://scenes/ingame/player/glue_spot.tscn")
const Mine = preload("res://scenes/ingame/player/mine.tscn")
const BallSpawn = preload("res://scenes/ingame/player/ball_spawn.tscn")

const MAX_EXPLOSION_TIME = 0.500

var damage = 1
var holdTime = 0.0
var inLauncArea = false

var explodeUpgradeActive = false
var explosionTime = 0.0
var explosionDamage = 1
var exploded = false

var fireBallUpgradeActive = false
var fireBallActiveTime = 3.0
var currentFireTime = 3.0
var fireBallStateEffectDuration = 0.5
var fireBallStateEffectDamage = 1.0
var fireBallStateEffectColor = Color(1, 0, 0)

@onready var shadowPosition = $ShadowSprite2D.position
@onready var shadowRotation = $ShadowSprite2D.rotation
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUpgradeUtils.connect("upgradeLoaded", Callable(self, "_on_upgradeLoaded"))
	PlayerUpgradeUtils.connect("upgraded", Callable(self, "_on_upgraded"))
	setExplosionUpgrade()
	setFireBallUpgrade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ShadowSprite2D.position = shadowPosition.rotated(rotation * -1)
	$ShadowSprite2D.rotation = shadowRotation - rotation
	
	if not inLauncArea and Input.is_action_pressed("ball_action"):
		holdTime = holdTime + delta * 2.0
		if holdTime > 1.0:
			holdTime = 1.0
		$Sprite2D.modulate = Color(1, 1 - holdTime, 0  - holdTime)
	elif not exploded:
		$Sprite2D.modulate = Color(1, 1, 1)
		holdTime = 0
	
	if holdTime >= 1.0:
		if not exploded:
			explode()
		explosionTime = explosionTime + delta
		var opaque = 1.0 - explosionTime / MAX_EXPLOSION_TIME
		$ExplosionArea2D/AnimatedSprite2D.modulate = Color(1, 1, 1, opaque)
		$Sprite2D.modulate = Color(1, 0, 0, opaque)
		if explosionTime >= MAX_EXPLOSION_TIME:
			in_off.emit()
			queue_free()
			
	if fireBallUpgradeActive:
		if currentFireTime < fireBallActiveTime:
			$FireArea2D.show()
			currentFireTime = currentFireTime + delta
			var areas = $FireArea2D.get_overlapping_areas()
			for area in areas:
				if area.has_method("addStateEffect"):
					var effect = SateEffect.new("glue")
					effect.duration = fireBallStateEffectDuration
					effect.colorChange = fireBallStateEffectColor
					effect.damageOverTime = fireBallStateEffectDamage
					area.addStateEffect(effect)
		else:
			$FireArea2D.hide()

func explode() -> void:
	exploded = true
	freeze = true
	if explodeUpgradeActive:
		$TrailParticles.emitting = false
		$ExplosionArea2D.show()
		$ExplosionArea2D/AnimatedSprite2D.play()
		var areas = $ExplosionArea2D.get_overlapping_areas()
		for area in areas:
			if area.has_method("applyDamage"):
				area.applyDamage(explosionDamage, "basic")
	

func leaveTable() -> void:
	in_off.emit()
	queue_free()

func hit(node: Node2D, type: String) -> void:
	if node.has_method("applyDamage"):
		node.applyDamage(damage, "basic")
	
	if type == "tree" && not $TreeHitParticle.emitting:
		$TreeHitParticle.restart()
	elif type == "enemy":
		pass # maybe add upgrade effect here

func launch(impulse: Vector2) -> void:
	self.apply_impulse(impulse)
	if fireBallUpgradeActive:
		currentFireTime = 0

func _on_upgradeLoaded(icon: UpgradeIcon) -> void:
	if PlayerUpgradeUtils.UpgradeType.BALL_SLOW_DOWN == icon.upgrade:
		var glue = GlueSpot.instantiate()
		glue.position = position
		get_parent().add_child(glue)
		icon.startTimer()
	elif PlayerUpgradeUtils.UpgradeType.BALL_SPAWN == icon.upgrade:
		if not inLauncArea:
			createBallSpawn(1, 1)
			createBallSpawn(-1, -1)
			if icon.level > 1:
				createBallSpawn(-1, 1)
				createBallSpawn(1, -1)
		icon.startTimer()
	elif PlayerUpgradeUtils.UpgradeType.BALL_MINE == icon.upgrade:
		var mine = Mine.instantiate()
		mine.position = position
		get_parent().add_child(mine)
		icon.startTimer()

func createBallSpawn(moveX: int, moveY: int) -> void:
	var offset = $CollisionShape2D.shape.radius * 2
	var ballSpawn = BallSpawn.instantiate()
	ballSpawn.position = Vector2(position.x + offset * moveX , position.y + offset * moveY)
	get_parent().add_child(ballSpawn)
	ballSpawn.launch(Vector2(BALL_SPAWN_LAUNCH_SPEED * moveX, BALL_SPAWN_LAUNCH_SPEED * moveY))

func _on_upgraded(upgrade: PlayerUpgradeUtils.UpgradeType) -> void:
	if PlayerUpgradeUtils.UpgradeType.BALL_EXPLODE == upgrade:
		setExplosionUpgrade()
	if PlayerUpgradeUtils.UpgradeType.BUMPER_SET_BALL_ON_FIRE == upgrade:
		setFireBallUpgrade()

func setExplosionUpgrade() -> void:
	if not PlayerUpgradeUtils.upgrades.has(PlayerUpgradeUtils.UpgradeType.BALL_EXPLODE):
		explodeUpgradeActive = false
		return
	var level = PlayerUpgradeUtils.upgrades[PlayerUpgradeUtils.UpgradeType.BALL_EXPLODE]
	if level > 0:
		explodeUpgradeActive = true
		explosionDamage = level
		$ExplosionArea2D/AnimatedSprite2D.scale = Vector2(level, level)
		$ExplosionArea2D/CollisionShape2D.scale = Vector2(level, level)

func setFireBallUpgrade() -> void:
	if not PlayerUpgradeUtils.upgrades.has(PlayerUpgradeUtils.UpgradeType.BUMPER_SET_BALL_ON_FIRE):
		fireBallUpgradeActive = false
		return
	var level = PlayerUpgradeUtils.upgrades[PlayerUpgradeUtils.UpgradeType.BUMPER_SET_BALL_ON_FIRE]
	if level > 0:
		fireBallUpgradeActive = true
		$FireArea2D/AnimatedSprite2D.scale = Vector2(level / 2.0, level / 2.0)
		$FireArea2D/CollisionShape2D.scale = Vector2(level / 2.0, level / 2.0)
