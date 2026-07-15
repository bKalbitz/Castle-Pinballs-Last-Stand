extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

var enemies: Array[AbstractEnemy] = [];

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add(enemey: AbstractEnemy) -> void:
	enemies.append(enemey);
	
func remove(enemey: AbstractEnemy) -> void:
	enemies.erase(enemey);
	
func removeAll() -> void:
	enemies = [];

func getEnemies() ->  Array[AbstractEnemy]:
	return enemies;
