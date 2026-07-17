extends Node

var enemies: Array[AbstractEnemy] = [];

func add(enemey: AbstractEnemy) -> void:
	enemies.append(enemey);
	
func remove(enemey: AbstractEnemy) -> void:
	enemies.erase(enemey);
	
func removeAll() -> void:
	enemies = [];

func getEnemies() ->  Array[AbstractEnemy]:
	return enemies;
