extends Area2D

signal destroyed
signal playerDamaged

@export var scorePoints = 10
@export var move_to: Vector2
var health = 1
var damage = 10
var dead = false
var speed = 100
var entityType = "enemy"
var speedEffectChange = 1.0

var stateEffects: Array[SateEffect] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	handleEffects(delta)
	handleMovement(delta)

func handleMovement(delta: float) -> void:
	var motion = position.direction_to(move_to)
	var activeSpeed = speed * speedEffectChange * delta
	var velocity = Vector2(motion.x * activeSpeed, motion.y * activeSpeed)
	var postitionBefore = position
	position = Vector2(position.x + velocity.x, position.y + velocity.y)
	var areas = get_overlapping_areas()
	for area in areas:
		if area.get("isBlockingEnemies"):
			motion = area.getEvadeVector(postitionBefore, motion)
			velocity = Vector2(motion.x * delta * speed, motion.y * delta * speed)
			position = Vector2(postitionBefore.x + velocity.x, postitionBefore.y + velocity.y)
			break

func handleEffects(delta: float) -> void:
	speedEffectChange = 1.0
	modulate = Color(1, 1, 1)
	var damage = 0.0
	var activeEffects: Array[SateEffect] = []
	for effect in stateEffects:
		modulate =  effect.getColorChange(modulate)
		if effect.speedEffect != 1.0:
			if speedEffectChange == 1.0:
				speedEffectChange =  effect.speedEffect
			else:	
				speedEffectChange = (speedEffectChange + effect.speedEffect) / 2 
		damage = damage + effect.damageOverTime
		if effect.process(delta):
			activeEffects.append(effect)
			
	stateEffects = activeEffects
	if damage > 0.0:
		applyDamage(damage * delta, "basic")

func leaveTable() -> void:
	playerDamaged.emit(damage)
	queue_free()

func applyDamage(damge: float, type: String) -> void:
	if not $OnHitParticle.emitting:
		$OnHitParticle.restart()
		$DamageSound.play()
	health = health - damge
	
	if health <= 0:
		dead = true
		$ShadowSprite2D.hide()
		$AnimatedSprite2D.hide()

func addStateEffect(newEffect: SateEffect) -> void:
	var found = false
	for effect in stateEffects:
		if effect.equal(newEffect):
			found = true
			effect.updateData(newEffect)
	
	if not found:
		stateEffects.append(newEffect)

func _on_on_hit_particle_finished() -> void:
	if health <= 0:
		destroyed.emit(scorePoints, self)
		queue_free()


func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("hit"):
		body.hit(self, "enemy")
