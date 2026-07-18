extends Area2D

var speed = IngameConfig.playerConfig.infanterySpeed
var health = IngameConfig.playerConfig.infanteryHealth
var damage = IngameConfig.playerConfig.infanteryDamage
var range = 64;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if health <= 0:
		return
		
	var enemy =  _findNearestEnemy()
	if not enemy:
		return
	
	var postitionBefore = position
	var motion = position.direction_to(enemy.position)
	var activeSpeed = speed * delta
	var velocity = Vector2(motion.x * activeSpeed, motion.y * activeSpeed)
	position = Vector2(position.x + velocity.x, position.y + velocity.y)
	
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get("isBlockingEnemies"):
			motion = area.getEvadeVector(postitionBefore, motion)
			velocity = Vector2(motion.x * delta * speed, motion.y * delta * speed)
			position = Vector2(postitionBefore.x + velocity.x, postitionBefore.y + velocity.y)
			break
	_handleAttack(enemy)

func _findNearestEnemy() -> AbstractEnemy:
	var enemy: AbstractEnemy
	var shortest: float
	for e in EnemyRegister.getEnemies():
		if e.dead:
			continue
		
		if not enemy:
			enemy = e
			shortest = position.distance_to(e.position)
		else:
			var toTest =  position.distance_to(e.position)
			if toTest < shortest:
				enemy = e
				shortest = toTest
	return enemy

func _handleAttack(enemy: AbstractEnemy) -> void:
	if position.distance_to(enemy.position) < range:
		if $AtackTimer.is_stopped():
			$AtackTimer.start()
			enemy.applyDamage(damage, "basic")
		if $AtackedTimer.is_stopped():
			$AtackedTimer.start()
			applyDamage(enemy.damage, "basic")

func applyDamage(damge: float, type: String) -> void:
	if health <= 0:
		return

	health = health - damge
	if not $OnHitParticle.emitting:
		$OnHitParticle.restart()
		$DamageSound.play()
	if health <= 0:
		$ShadowSprite2D.hide()
		$AnimatedSprite2D.hide()
			

func _on_on_hit_particle_finished() -> void:
	if health <= 0:
		queue_free()
