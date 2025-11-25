extends Panel

var LevelSelectScene = preload("res://scenes/Menu/level_select_button.tscn") 
signal pressed_back
signal level_selected

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var levels = loadData()
	var preButton = $LevelSelectBoxContainer/BackButton
	for levelData in levels:
		var levelName = levelData["name"]
		var levelIcon = levelData["thumbnail"]
		var levelScene = levelData["scene"]
		var levelSelection = LevelSelectScene.instantiate();
		levelSelection.setData(levelName, levelIcon, levelScene)
		$LevelSelectBoxContainer.add_child(levelSelection)
		preButton.focus_neighbor_bottom = levelSelection.get_path()
		levelSelection.focus_neighbor_top = preButton.get_path()
		levelSelection.connect("level_selected", Callable(self, "_on_level_selected"))
		preButton = levelSelection

func loadData() -> Array:
	var jsonString = FileAccess.get_file_as_string("res://data/levels.json")
	return JSON.parse_string(jsonString)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func showLevelSelect() -> void:
	show()
	$LevelSelectBoxContainer/BackButton.grab_focus.call_deferred()

func _on_level_selected(levelScene: String) -> void:
	level_selected.emit(levelScene)

func _on_back_button_pressed() -> void:
	pressed_back.emit()
