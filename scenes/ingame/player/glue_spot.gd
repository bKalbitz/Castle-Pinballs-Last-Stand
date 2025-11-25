extends Area2D

var lifeTimeDuration = 3.0
var lifeTime = 0.0
var effectDuration = 1.0
var effectColor = Color(0.5, 0.0, 1.0)
var effectSpeed = 0.5
var effectDamage = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerUpgradeUtils.connect("upgraded", Callable(self, "_on_upgraded"))
	setValueUpgrade()

func _on_upgraded(upgrade: PlayerUpgradeUtils.UpgradeType) -> void:
	if PlayerUpgradeUtils.UpgradeType.BALL_SLOW_DOWN == upgrade:
		setValueUpgrade()

func setValueUpgrade() -> void:
	if not PlayerUpgradeUtils.upgrades.has(PlayerUpgradeUtils.UpgradeType.BALL_SLOW_DOWN):
		return
	var level = PlayerUpgradeUtils.upgrades[PlayerUpgradeUtils.UpgradeType.BALL_SLOW_DOWN]
	if level > 0:
		scale = Vector2(level, level * 0.5)
		if level > 2:
			effectDamage = 1.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifeTime = lifeTime + delta
	if lifeTime >= lifeTimeDuration:
		queue_free()
		return
	
	var areas = get_overlapping_areas()
	for area in areas:
		if area.has_method("addStateEffect"):
			var effect = SateEffect.new("glue")
			effect.duration = effectDuration
			effect.colorChange = effectColor
			effect.speedEffect = effectSpeed
			if effectDamage > 0.0:
				effect.damageOverTime = effectDamage
			area.addStateEffect(effect)
