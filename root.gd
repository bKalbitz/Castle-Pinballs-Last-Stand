class_name Root extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SimpleSettings.config_files = {
		game = {
			path = "user://game.ini",
		},
		score = {
			path = "user://score.ini",
		}
	}
	SimpleSettings.load()
	$IngameRoot.setPaused(true)
	setVideoSettings()
	applyAudioSettings()
	$IngameRoot.hide()
	$MainMenu.showMenu()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("open_menu"):
		showMenu()

func showMenu() -> void:
	$IngameRoot.setPaused(true)
	$IngameRoot.hide()
	$MainMenu.showMenu()
	
func _on_main_menu_continue_game() -> void:
	$MainMenu.hide()
	$IngameRoot.show()
	$IngameRoot.setPaused(false)


func _on_main_menu_new_game(levelScene: String) -> void:
	$MainMenu.ingame = true
	$MainMenu.hide()
	$IngameRoot.show()
	$IngameRoot.newGame(levelScene)


func _on_main_menu_video_settings_changed() -> void:
	setVideoSettings()

func setVideoSettings() -> void:
	var fullscreen = SimpleSettings.get_value("game", "video/fullscreen", false)
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen else DisplayServer.WINDOW_MODE_WINDOWED)
	var text =  SimpleSettings.get_value("game", "video/resolution", "1980x1080")
	var values = text.split_floats("x")
	DisplayServer.window_set_size(Vector2i(values[0], values[1]))
	$MainMenu.recalcView()
	$IngameRoot.recalcView()


func _on_ingame_root_game_over(levelName: String, score: int) -> void:
	$IngameRoot.setPaused(true)
	$IngameRoot.hide()
	$MainMenu.gameOver(levelName, score)
	
static func applyAudioSettings() -> void:
	var volume = SimpleSettings.get_value("game", "sound/volume", 1.0)
	var busIndex = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_volume_db(busIndex, linear_to_db(volume))
	AudioServer.set_bus_mute(busIndex, volume < 0.05)
