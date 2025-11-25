extends RigidBody2D

var damage = 0.5
var duration = 4.0
var lifeTime = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifeTime = lifeTime + delta
	var colorChange = 1.0 - lifeTime / duration
	modulate = Color(1, colorChange, colorChange)
	if lifeTime >= duration:
		queue_free()

func leaveTable() -> void:
	queue_free()

func launch(impulse: Vector2) -> void:
	self.apply_impulse(impulse)

func hit(node: Node2D, type: String) -> void:
	if node.has_method("applyDamage"):
		node.applyDamage(damage, "basic")
