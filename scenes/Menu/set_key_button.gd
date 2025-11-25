extends Button

@export var action: String
@export var action_key_index = 0

func _init():
	toggle_mode = true

func _ready() -> void:
	set_process_unhandled_input(false)
	update_key_text()

func _process(delta: float) -> void:
	pass

func _toggled(button_pressed):
	set_process_unhandled_input(button_pressed)
	if button_pressed:
		text = "... Awaiting Input ..."
		release_focus()
	else:
		update_key_text()
		grab_focus()

func _unhandled_input(event):
	if event.pressed:
		var inputs = InputMap.action_get_events(action)
		InputMap.action_erase_events(action)
		for i in inputs.size():
			if i == action_key_index:
				InputMap.action_add_event(action, event)
			else:
				InputMap.action_add_event(action, inputs[i])
		button_pressed = false


func update_key_text():
	text = "%s" % InputMap.action_get_events(action)[action_key_index].as_text()


func _on_draw() -> void:
	update_key_text()
