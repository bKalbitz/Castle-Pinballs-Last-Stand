extends Node2D

signal newGame
signal continueGame
signal videoSettingsChanged

var ingame = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func showMenu() -> void:
	show()
	recalcView()
	$MainMenuPanel.show()
	$OptionMenuPanel.hide()
	$OptionMenuPanel.loadSettiings()
	$LevelSelectPanel.hide()
	$MainMenuPanel/MainMenuVBoxContainer/ContinueButton.disabled = not ingame
	$MenuCamera2D.make_current()
	$MainMenuPanel/MainMenuVBoxContainer/NewGameButton.grab_focus.call_deferred()

func recalcView() -> void:
	$MainMenuPanel.size = get_viewport_rect().size
	$OptionMenuPanel.size = get_viewport_rect().size
	$LevelSelectPanel.size = get_viewport_rect().size
	$HighScoresPanel.size = get_viewport_rect().size
	$MenuCamera2D.position = Vector2($MainMenuPanel.size.x / 2, $MainMenuPanel.size.y / 2)
	var bottonsContainer = $MainMenuPanel/MainMenuVBoxContainer
	bottonsContainer.position = Vector2($MainMenuPanel.size.x / 2 - bottonsContainer.size.x / 2, $MainMenuPanel.size.y / 2  - bottonsContainer.size.y / 2)
	# TODO this belongs in the sub scenes
	var optionContainer = $OptionMenuPanel/VBoxContainer
	optionContainer.position = Vector2($OptionMenuPanel.size.x / 2 - optionContainer.size.x / 2, $OptionMenuPanel.size.y / 2  - optionContainer.size.y / 2)
	var levelSelectContainer = $LevelSelectPanel/LevelSelectBoxContainer
	levelSelectContainer.position = Vector2($OptionMenuPanel.size.x / 2 - levelSelectContainer.size.x / 2, $OptionMenuPanel.size.y / 2  - levelSelectContainer.size.y / 2)
	var scoreContainer = $HighScoresPanel/VBoxContainer
	scoreContainer.position = Vector2($OptionMenuPanel.size.x / 2 - scoreContainer.size.x / 2, $OptionMenuPanel.size.y / 2  - scoreContainer.size.y / 2)

func _on_continue_button_pressed() -> void:
	continueGame.emit()


func _on_new_game_button_pressed() -> void:
	$MainMenuPanel.hide()
	$LevelSelectPanel.showLevelSelect()

func _on_level_select_panel_pressed_back() -> void:
	$LevelSelectPanel.hide()
	$MainMenuPanel.show()
	$MainMenuPanel/MainMenuVBoxContainer/NewGameButton.grab_focus.call_deferred()

func _on_level_select_panel_level_selected(levelScene: String) -> void:
	newGame.emit(levelScene)

func _on_option_button_pressed() -> void:
	$OptionMenuPanel.loadSettiings()
	$MainMenuPanel.hide()
	$OptionMenuPanel.showOptons()


func _on_exit_button_pressed() -> void:
	get_tree().quit(0)


func _on_option_menu_panel_saved(videoChange: bool,  controlChange: bool) -> void:
	if videoChange:
		videoSettingsChanged.emit()
	if controlChange:
		setControls()
	exitOptions()


func _on_option_menu_panel_aborted() -> void:
	exitOptions()

func exitOptions() -> void:
	$OptionMenuPanel.hide()
	$MainMenuPanel.show()
	$MainMenuPanel/MainMenuVBoxContainer/NewGameButton.grab_focus.call_deferred()
	

func setControls() -> void:
	pass

func gameOver(levelName: String, score: int) -> void:
	ingame = false
	showMenu()
	$MainMenuPanel.hide()
	$HighScoresPanel.submitScore(levelName, score)


func _on_highscore_button_pressed() -> void:
	$MainMenuPanel.hide()
	$HighScoresPanel.showScore()


func _on_high_scores_panel_back_to_menu() -> void:
	$HighScoresPanel.hide()
	$MainMenuPanel.show()
	$MainMenuPanel/MainMenuVBoxContainer/NewGameButton.grab_focus.call_deferred()
