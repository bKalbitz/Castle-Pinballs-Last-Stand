extends Panel

signal saved
signal aborted

var resolution
var fullscreen
var volume: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func loadSettiings() -> void:
	fullscreen = SimpleSettings.get_value("game", "video/fullscreen", false)
	resolution = SimpleSettings.get_value("game", "video/resolution", "1980x1080")
	loadActionInput("flipper_left")
	loadActionInput("flipper_right")
	loadActionInput("ball_action")
	loadActionInput("ball_dodge_up")
	loadActionInput("ball_dodge_down")
	loadActionInput("ball_dodge_right")
	loadActionInput("ball_dodge_left")
	loadActionInput("open_menu")
	volume = SimpleSettings.get_value("game", "sound/volume", 1.0)
	
	var resOptions = $VBoxContainer/TabContainer/Video/ResolutionHBoxContainer/OptionButton
	for i in resOptions.item_count:
		var text = resOptions.get_item_text(i)
		if text == resolution:
			resOptions.selected = i
			break
	$VBoxContainer/TabContainer/Video/FullscreenCheckBox.button_pressed = fullscreen
	$VBoxContainer/TabContainer/Sound/FXHBoxContainer/HSlider.value = volume;

func loadActionInput(action: String) -> Array[InputEvent]:
	var input = SimpleSettings.get_value("game", str("control/action_", action), null)
	if not input:
		input = InputMap.action_get_events(action)
	else:
		setInputMapEvent(action, input)
	return input

func setInputMapEvent(action: String, input: Array[InputEvent]) -> void:
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, input[0])
	InputMap.action_add_event(action, input[1])

func showOptons() -> void:
	loadSettiings()
	show()
	$VBoxContainer/HBoxContainer/SaveButton.grab_focus.call_deferred()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_save_button_pressed() -> void:
	var resOptions = $VBoxContainer/TabContainer/Video/ResolutionHBoxContainer/OptionButton
	var newResolution = resOptions.get_item_text(resOptions.selected)
	SimpleSettings.set_value("game", "video/resolution", newResolution)
	var newFullscreen = $VBoxContainer/TabContainer/Video/FullscreenCheckBox.button_pressed
	SimpleSettings.set_value("game", "video/fullscreen", $VBoxContainer/TabContainer/Video/FullscreenCheckBox.button_pressed)
	if volume != $VBoxContainer/TabContainer/Sound/FXHBoxContainer/HSlider.value:
		volume = $VBoxContainer/TabContainer/Sound/FXHBoxContainer/HSlider.value
		SimpleSettings.set_value("game", "sound/volume", volume)
		Root.applyAudioSettings()
	saveAction("flipper_left")
	saveAction("flipper_right")
	saveAction("ball_action")
	saveAction("ball_dodge_up")
	saveAction("ball_dodge_down")
	saveAction("ball_dodge_left")
	saveAction("ball_dodge_right")
	saveAction("open_menu")
	SimpleSettings.save()
	
	saved.emit(newResolution != resolution || newFullscreen != fullscreen)

func saveAction(action: String) -> void:
	SimpleSettings.set_value("game", str("control/action_", action), InputMap.action_get_events(action))


func _on_cancel_button_pressed() -> void:
	aborted.emit()
