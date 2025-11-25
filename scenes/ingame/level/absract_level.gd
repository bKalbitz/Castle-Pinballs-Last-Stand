class_name AbstractLevel extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func getLeftFlipper() -> Flipper:
	return null

func getRightFlipper() -> Flipper:
	return null

func getEnemyMoveTo() -> Vector2:
	return Vector2.ZERO

func getLaunchArea() -> Area2D:
	return null

func getEnemySpawnPosX() -> int:
	return 0
	
func getEnemySpawnOffsetX() -> int:
	return 0

func getEnemySpawnPosY() -> int:
	return 0
	
func getEnemySpawnOffsetY() -> int:
	return 0

func getLevelName() -> String:
	return "null"
