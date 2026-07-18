extends Node

var enemyConfig: Dictionary[String, EnemyConfig] = _loadEnemyConfig()
var playerConfig: PlayerConfig = _loadPlayerConfig()

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

func _loadPlayerConfig() -> PlayerConfig:
	var playerConfig = PlayerConfig.new()
	var jsonString = FileAccess.get_file_as_string("res://data/player_config.json")
	var data = JSON.parse_string(jsonString)
	playerConfig.ballSpawnlaunchSpeed = data["ballSpawnlaunchSpeed"]
	playerConfig.ballDodgeForce = data["ballDodgeForce"]
	playerConfig.ballDamage = data["ballDamage"]
	playerConfig.ballMaxExplosionTime = data["ballMaxExplosionTime"]
	playerConfig.ballExplosionDamage = data["ballExplosionDamage"]
	playerConfig.ballFireBallActiveTime = data["ballFireBallActiveTime"]
	playerConfig.ballFireBallActiveTime = data["ballFireBallActiveTime"]
	playerConfig.ballFireBallStateEffectDuration = data["ballFireBallStateEffectDuration"]
	playerConfig.ballFireBallStateEffectDamage = data["ballFireBallStateEffectDamage"]
	playerConfig.flipperRotationSpeed = data["flipperRotationSpeed"]
	playerConfig.flipperDamage = data["flipperDamage"]
	playerConfig.ballSpawnDamage = data["ballSpawnDamage"]
	playerConfig.ballSpawnDuration = data["ballSpawnDuration"]
	playerConfig.bumperTowerDamage = data["bumperTowerDamage"]
	playerConfig.bumperTowerInitialTargetCount = data["bumperTowerInitialTargetCount"]
	playerConfig.bumperTowerBallLaunchSpeed = data["bumperTowerBallLaunchSpeed"]
	playerConfig.glueLifeTimeDuration = data["glueLifeTimeDuration"]
	playerConfig.glueEffectDuration = data["glueEffectDuration"]
	playerConfig.glueEffectSpeed = data["glueEffectSpeed"]
	playerConfig.glueInitialEffectDamage = data["glueInitialEffectDamage"]
	playerConfig.glueUpgradedEffectDamage = data["glueUpgradedEffectDamage"]
	playerConfig.infanterySpeed = data["infanterySpeed"]
	playerConfig.infanteryHealth = data["infanteryHealth"]
	playerConfig.infanteryDamage = data["infanteryDamage"]
	playerConfig.launchAreaImpulseY = data["launchAreaImpulseY"]
	playerConfig.slingShotImpulse = data["slingShotImpulse"]
	playerConfig.mineLifeTimePerLevel = data["mineLifeTimePerLevel"]
	playerConfig.mineEffectDuration = data["mineEffectDuration"]
	playerConfig.mineEffectDamage = data["mineEffectDamage"]
	playerConfig.mineExplosionDamage = data["mineExplosionDamage"]
	return playerConfig

func getEnemyConfig(name: String) -> EnemyConfig:
	return enemyConfig[name]

class EnemyConfig:
	var name: String
	var health: float
	var damage: float
	var speed: float
	var scorePoints: float

class PlayerConfig:
	var ballSpawnlaunchSpeed: float
	var ballDodgeForce: float
	var ballDamage: float
	var ballMaxExplosionTime: float
	var ballExplosionDamage: float
	var ballFireBallActiveTime: float
	var ballFireBallStateEffectDuration: float
	var ballFireBallStateEffectDamage: float
	var flipperRotationSpeed: float
	var flipperDamage: float
	var ballSpawnDamage: float
	var ballSpawnDuration: float
	var bumperTowerDamage: float
	var bumperTowerInitialTargetCount: int
	var bumperTowerBallLaunchSpeed: float
	var glueLifeTimeDuration: float
	var glueEffectDuration: float
	var glueEffectSpeed: float
	var glueInitialEffectDamage: float
	var glueUpgradedEffectDamage: float
	var infanterySpeed: float
	var infanteryHealth: float
	var infanteryDamage: float
	var launchAreaImpulseY: float
	var slingShotImpulse: float
	var mineLifeTimePerLevel: float
	var mineEffectDuration: float
	var mineEffectDamage: float
	var mineExplosionDamage: float
