class_name EnemyBlockingArea2D extends Area2D

var isBlockingEnemies = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func getEvadeVector(enemyPosition: Vector2, motion: Vector2) -> Vector2:
	if enemyPosition.x > global_position.x:
		return Vector2(1, 0) 
	return Vector2(-1, 0)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
