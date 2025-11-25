extends GPUParticles2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fire(normelizedDirection: Vector2) -> void:
	process_material.direction = Vector3(normelizedDirection.x * 1000, normelizedDirection.y * 1000, 0)
	restart()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_finished() -> void:
	queue_free()
