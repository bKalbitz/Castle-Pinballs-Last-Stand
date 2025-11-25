extends EnemyBlockingArea2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getEvadeVector(enemyPosition: Vector2, motion: Vector2) -> Vector2:
	if get_parent().get("mirrored"):
		return Vector2(-1, 0)
	return Vector2(1, 0)
