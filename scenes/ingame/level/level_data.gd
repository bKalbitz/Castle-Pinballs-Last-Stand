class_name LevelData extends Object

var name: String
var scenePath: String
var enemies: Dictionary[String, PackedScene]
var enemySpawns: Array[EnemySpawn]

func loadData(data: Dictionary) -> void:
	name = data["name"]
	scenePath = data["scene"]

	loadEnemies(FileAccess.get_file_as_string(data["enemies"]))
	loadEnemySpawns(FileAccess.get_file_as_string(data["enemySpawns"]))

func loadEnemies(resourcePath: String) -> void:
	enemies = {};
	var data = JSON.parse_string(resourcePath)
	for enemy in data:
		enemies[enemy["name"]] = load(enemy["resource"])

func loadEnemySpawns(resourcePath: String) -> void:
	var data = JSON.parse_string(resourcePath)
	enemySpawns = []
	for config in data:
		var enemySpawn = EnemySpawn.new()
		enemySpawn.activationTime = config["startTime"]
		enemySpawn.nextSpawnTimer = config["spawnTimer"]
		enemySpawn.spawnCount = config["spawnCount"]
		for enemy in config["spawnPool"]:
			enemySpawn.spawnPool.append(enemy)
		enemySpawns.append(enemySpawn)

func getEnemySpawn(gameTime: int) -> EnemySpawn:
	var enemySpawn: EnemySpawn
	for e in enemySpawns:
		if e.activationTime > gameTime:
			break
		enemySpawn = e
	return enemySpawn

func getSpawns(gameTime: int) -> Array[PackedScene]:
	var spawns: Array[PackedScene] = []
	var enemySpawn = getEnemySpawn(gameTime)
	if enemySpawn:
		for i in enemySpawn.spawnCount:
			var next = enemySpawn.spawnPool[randi() % enemySpawn.spawnPool.size()]
			var scene = enemies[next]
			if scene:
				spawns.append(scene)
	return spawns

func getNextSpawnTimer(gameTime: int) -> float:
	var enemySpawn = getEnemySpawn(gameTime)
	if enemySpawn:
		return enemySpawn.nextSpawnTimer
	return 1.0

class EnemySpawn:
	var activationTime: int
	var nextSpawnTimer: float
	var spawnCount: int
	var spawnPool: Array[String] = []
