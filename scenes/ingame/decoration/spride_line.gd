extends Path2D

var isInit = false
@export var step_size = 32
@export var scene_path = "res://scenes/ingame/decoration/tree.tscn"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not isInit:
		drawTreeLine()
		isInit = true
	
func drawTreeLine() -> void:
	var i = 0
	var scence = load(scene_path)
	while i < curve.point_count - 1:
		var point1 = curve.get_point_position(i)
		var sprite = scence.instantiate()
		sprite.global_position = point1
		get_parent().add_child(sprite)
		var point2 =  curve.get_point_position(i + 1)
		var leangth = point1.distance_to(point2)
		var normalize = point1.direction_to(point2)
		var newPoint = Vector2(point1.x + normalize.x * step_size, point1.y + normalize.y * step_size)
		var count = 1
		while point1.distance_to(newPoint) < leangth:
			count = count + 1
			sprite = scence.instantiate()
			sprite.global_position = newPoint
			get_parent().add_child(sprite)
			newPoint = Vector2(point1.x + normalize.x * step_size * count, point1.y + normalize.y * step_size * count)
		i = i + 1
