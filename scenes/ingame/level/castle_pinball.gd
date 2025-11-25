extends AbstractLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_level_bottom_area_entered(area: Area2D) -> void:
	if area.has_method("leaveTable"):
		area.leaveTable() # Replace with function body.


func _on_level_bottom_body_entered(body: Node2D) -> void:
	if body.has_method("leaveTable"):
		body.leaveTable()

func getLeftFlipper() -> Flipper:
	return $LeftFlipper

func getRightFlipper() -> Flipper:
	return $RightFlipper

func getEnemyMoveTo() -> Vector2:
	return $LevelBottom/OutOfBounds.position
	
func getLaunchArea() -> Area2D:
	return $LaunchArea2D

func getEnemySpawnPosX() -> int:
	return 200
	
func getEnemySpawnOffsetX() -> int:
	return 1000

func getEnemySpawnPosY() -> int:
	return 100
	
func getEnemySpawnOffsetY() -> int:
	return 200

func getLevelName() -> String:
	return "Castle Pinball"
