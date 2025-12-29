extends Node2D
const MAX_HEALTH = 1000.0
const BALL_IN_OFF_HEALTH_LOST_MULTIPLIER =  0.05
const LEVEL_UP_DELTA: int = 100
const LEVEL_UP_MULTIPLIER = 1.5

## TODO this magic numbers should define by the level
const CAMERA_Y_OFFSET_TO_FLIPPER = 70
const SPLITSCREEN_X_OFFSET_TO_FLIPPER = 150
const SPLITSCREEN_Y_OFFSET_TO_FLIPPER = -60

const GUI_OFFSET = 5

signal gameOver

var Ball = preload("res://scenes/ingame/player/ball.tscn")
var Skelet = preload("res://scenes/ingame/enemy/skeleton_warrior.tscn")
var Minotaur = preload("res://scenes/ingame/enemy/minotaur.tscn")
var enememy_types = [Skelet, Minotaur]
var camera_follow_ball = true
var current_ball
var spawnCount = 5
var level: AbstractLevel
var leftFliper: Flipper
var rightFliper: Flipper
var launchArea: LaunchArea
var enemyMoveTo: Vector2
var health = MAX_HEALTH
var score: int = 0
var xp: int = 0
var playerLevel: int = 0
var nextPlayerLevelXp: int = LEVEL_UP_DELTA
var repairLevel = 0
var repairReady = false
var baseRepairRate = 0.05

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_ball = $Ball
	PlayerUpgradeUtils.connect("upgradeLoaded", Callable(self, "_on_upgradeLoaded"))
	
func _on_upgradeLoaded(icon: UpgradeIcon) -> void:
	if PlayerUpgradeUtils.UpgradeType.REPAIR == icon.upgrade:
		icon.startTimer()
		repairLevel = icon.level
		repairReady = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if camera_follow_ball && current_ball:
		var y = current_ball.position.y
		var maxY = leftFliper.position.y + CAMERA_Y_OFFSET_TO_FLIPPER - get_viewport_rect().size.y / 2
		if y > maxY:
			y = maxY
		var x = current_ball.position.x
		var maxX = launchArea.position.x + launchArea.getWidth()  - get_viewport_rect().size.x / 2
		if x > maxX:
			x = maxX
		$Camera2D.position = Vector2(x, y)
		$IngameHud.setPosition(Vector2(x - get_viewport_rect().size.x / 2 + GUI_OFFSET, y - get_viewport_rect().size.y / 2 + GUI_OFFSET ))
	
	if repairReady:
		repairReady = false
		updateHealth(MAX_HEALTH * repairLevel * baseRepairRate)

func updateHealth(add: int) -> void:
	health = health + add
	if health > MAX_HEALTH:
			health =  MAX_HEALTH
	$IngameHud.setHealth(health, MAX_HEALTH)
	if health <= 0:
		gameOver.emit(level.getLevelName(), score)
	
func _on_ball_in_off(loseHealth = true) -> void:
	var newBall = Ball.instantiate()
	newBall.global_position = launchArea.position
	newBall.connect("in_off", Callable(self, "_on_ball_in_off"))
	add_child(newBall)
	current_ball = newBall
	if loseHealth:
		updateHealth(MAX_HEALTH * BALL_IN_OFF_HEALTH_LOST_MULTIPLIER * -1)


func _on_spawn_timer_timeout() -> void:
	for i in spawnCount:
		var x = level.getEnemySpawnPosX() + (randi() % level.getEnemySpawnOffsetX())
		var y = level.getEnemySpawnPosY() + (randi() % level.getEnemySpawnOffsetY())
		var target = enemyMoveTo
		var enemy = enememy_types[randi() % enememy_types.size()].instantiate()
		enemy.move_to = target
		enemy.position = Vector2(x, y)
		enemy.connect("destroyed", Callable(self, "_on_enemy_destroyed"))
		enemy.connect("playerDamaged", Callable(self, "_on_enemy_playerDamaged"))
		add_child(enemy)

func _on_enemy_destroyed(addScore: int, enemy: Area2D) -> void:
	score = score + addScore
	xp = xp + addScore
	if xp > nextPlayerLevelXp:
		levelUp()
	$IngameHud.setScore(score)
	$IngameHud.setXp(xp, nextPlayerLevelXp)

func levelUp() -> void:
	playerLevel = playerLevel + 1
	xp = xp % nextPlayerLevelXp
	nextPlayerLevelXp = LEVEL_UP_DELTA * playerLevel * LEVEL_UP_MULTIPLIER
	$LevelUpHud.position = Vector2($Camera2D.position.x - get_viewport().get_visible_rect().size.x / 2 + GUI_OFFSET, $Camera2D.position.y)
	$LevelUpHud.showUprgradeOptions()

func _on_enemy_playerDamaged(damageToPlayer: float) -> void:
	updateHealth(damageToPlayer * -1)

func setPaused(_paused: bool) -> void:
	if not _paused:
		$Camera2D.make_current()
	get_tree().paused = _paused

func newGame(levelScene: String) -> void:
	if not levelScene:
		return
	if level:
		level.queue_free()
	get_tree().call_group("reset_game_group", "queue_free")
	$LevelUpHud.hide()
	health = MAX_HEALTH
	xp = 0
	score = 0
	playerLevel = 0
	nextPlayerLevelXp = LEVEL_UP_DELTA
	level = load(levelScene).instantiate()
	$IngameHud.setScore(0)
	$IngameHud.setHealth(MAX_HEALTH, MAX_HEALTH)
	$IngameHud.setXp(xp, nextPlayerLevelXp)
	$IngameHud.clearUpgrades()
	add_child(level)
	leftFliper = level.getLeftFlipper()
	rightFliper = level.getRightFlipper()
	enemyMoveTo = level.getEnemyMoveTo()
	launchArea = level.getLaunchArea()
	var splitSceenX = leftFliper.position.x + SPLITSCREEN_X_OFFSET_TO_FLIPPER - get_viewport_rect().size.x / 2
	var splitScreenY = leftFliper.position.y + SPLITSCREEN_Y_OFFSET_TO_FLIPPER
	$SplitScreen.setFocus(Vector2(splitSceenX, splitScreenY))
	_on_ball_in_off(false)
	recalcView()
	PlayerUpgradeUtils.reset()
	PlayerUpgradeUtils.registerHud($IngameHud, $LevelUpHud)
	setPaused(false)

func recalcView() -> void:
	$SplitScreen.initSplitScreenView()
	$IngameHud.setWidth(get_viewport().get_visible_rect().size.x - GUI_OFFSET * 2)
	$LevelUpHud.setWidth(get_viewport().get_visible_rect().size.x - GUI_OFFSET * 2)
