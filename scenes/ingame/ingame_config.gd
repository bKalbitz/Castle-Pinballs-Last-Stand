extends Node

var enemyConfig: Dictionary[String, EnemyConfig] = _loadEnemyConfig()

func _loadEnemyConfig() -> Dictionary[String, EnemyConfig]:
	var jsonString = FileAccess.get_file_as_string("res://data/enemies.json")
	var data = JSON.parse_string(jsonString)
	var config:Dictionary[String, EnemyConfig] = {}
	for enemyData in data:
		var enemyConfig = EnemyConfig.new()
		enemyConfig.name = enemyData["name"]
		enemyConfig.health = enemyData["health"]
		enemyConfig.speed = enemyData["speed"]
		enemyConfig.scorePoints = enemyData["scorePoints"]
		config[enemyConfig.name] = enemyConfig
		
	return config

func getEnemyConfig(name: String) -> EnemyConfig:
	return enemyConfig[name]

class EnemyConfig:
	var name: String
	var health: float
	var damage: float
	var speed: float
	var scorePoints: float
