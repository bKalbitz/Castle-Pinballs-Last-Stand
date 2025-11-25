class_name LevelSelectButton extends Button

signal level_selected
var levelScene: String

func setData(_name: String, _icon: String, _levelScene: String) -> void:
	text = _name
	icon = load(_icon)
	levelScene = _levelScene
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	level_selected.emit(levelScene)
