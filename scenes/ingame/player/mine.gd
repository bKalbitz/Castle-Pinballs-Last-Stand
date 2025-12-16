extends Node2D

const LIFE_TIME_PER_LEVEL = 3.0
const MAX_EXPLOSION_TIME = 0.500

var lifeTimeDuration = LIFE_TIME_PER_LEVEL
var lifeTime = 0.0
var addBurnEffect = false
var effectDuration = 1.0
var effectColor = Color(1.0, 0.0, 0.0)
var effectDamage = 1.0

var explosionDamage = 1.0
var explosionTime = 0.0
var exploded = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUpgradeUtils.connect("upgraded", Callable(self, "_on_upgraded"))
	setValueUpgrade()

func _on_upgraded(upgrade: PlayerUpgradeUtils.UpgradeType) -> void:
	if PlayerUpgradeUtils.UpgradeType.BALL_SLOW_DOWN == upgrade:
		setValueUpgrade()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if exploded:
		explosionTime = explosionTime + delta
		var opaque = 1.0 - explosionTime / MAX_EXPLOSION_TIME
		$ExplosionArea2D/AnimatedSprite2D.modulate = Color(1, 1, 1, opaque)
		$MineArea2D/Sprite2D.modulate = Color(1, 0, 0, opaque)
		if explosionTime >= MAX_EXPLOSION_TIME:
			queue_free()
	else:
		if lifeTime > lifeTimeDuration:
			queue_free()
		else:
			lifeTime = lifeTime + delta
			var areas = $MineArea2D.get_overlapping_areas()
			for area in areas:
				if area.has_method("applyDamage") && area.get("entityType") == "enemy" && not area.get("dead"):
					explode()
					break

func explode() -> void:
	exploded = true
	$ExplosionSound.play()
	$ExplosionArea2D.show()
	$ExplosionArea2D/AnimatedSprite2D.play()
	var areas = $ExplosionArea2D.get_overlapping_areas()
	for area in areas:
		if area.has_method("applyDamage"):
			area.applyDamage(explosionDamage, "basic")
			if addBurnEffect && area.has_method("addStateEffect"):
				var effect = SateEffect.new("fire")
				effect.duration = effectDuration
				effect.colorChange = effectColor
				effect.damageOverTime = effectDamage
				area.addStateEffect(effect)

func setValueUpgrade() -> void:
	if not PlayerUpgradeUtils.upgrades.has(PlayerUpgradeUtils.UpgradeType.BALL_MINE):
		lifeTimeDuration = LIFE_TIME_PER_LEVEL
		return
	var level = PlayerUpgradeUtils.upgrades[PlayerUpgradeUtils.UpgradeType.BALL_MINE]
	if level > 0:
		lifeTimeDuration = LIFE_TIME_PER_LEVEL * level
		var explosionScale = level / 2.0
		$ExplosionArea2D/AnimatedSprite2D.scale = Vector2(explosionScale, explosionScale)
		$ExplosionArea2D/CollisionShape2D.scale = Vector2(explosionScale, explosionScale)
		if level > 2:
			addBurnEffect = true
