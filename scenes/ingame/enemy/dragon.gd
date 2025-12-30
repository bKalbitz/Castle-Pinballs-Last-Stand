extends AbstractEnemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	health = 5
	damage = 30
	speed = 35
	hitParticleColor = Color(0.8, 0.1, 0.0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super(delta)

func applyDamage(damge: float, type: String) -> void:
	super(damge, type)
	if not $OnHitParticle.emitting:
		$OnHitParticle.restart()
		$DamageSound.play()
	
	if dead:
		$ShadowSprite2D.hide()
		$AnimatedSprite2D.hide()

func _on_on_hit_particle_finished() -> void:
	if health <= 0:
		destroyed.emit(scorePoints, self)
		queue_free()

func _on_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	if body.has_method("hit"):
		body.hit(self, "enemy")
