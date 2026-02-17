class_name LevelSelectButton extends Button

signal level_selected
var levelData: Dictionary

func setData(_name: String, _icon: String, _levelData: Dictionary) -> void:
	text = _name
	icon = load(_icon)
	levelData = _levelData
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	level_selected.emit(levelData)
