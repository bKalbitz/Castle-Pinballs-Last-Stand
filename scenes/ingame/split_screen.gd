extends Node2D

var splitScreenLimitY = 0
var focus: Vector2 = Vector2.ZERO
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func setFocus(_focus: Vector2) -> void:
	focus = _focus
	initSplitScreenView()

func initSplitScreenView() -> void:
	var viewSize = get_viewport().get_visible_rect().size
	$DelimiterLine2D.set_point_position(1, Vector2(viewSize.x, 0))
	$SubViewportContainer.size = Vector2(viewSize.x, viewSize.y / 4)
	$SubViewportContainer/SubViewport.world_2d = get_viewport().world_2d
	var cameraY = focus.y
	splitScreenLimitY = cameraY - $SubViewportContainer.size.y / 2 - viewSize.y / 2
	$SubViewportContainer/SubViewport/Camera2D.position = Vector2(focus.x + viewSize.x/2, cameraY)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var y = get_viewport().get_camera_2d().position.y
	var x = get_viewport().get_camera_2d().position.x - get_viewport_rect().size.x / 2
	if y > splitScreenLimitY:
		if $SubViewportContainer.visible:
			$SubViewportContainer.hide()
			$DelimiterLine2D.hide()
			pass
	else:
		if not $SubViewportContainer.visible:
			$SubViewportContainer.show()
			$DelimiterLine2D.show()
			pass
	var posY = y + $SubViewportContainer.size.y
	$DelimiterLine2D.position = Vector2(x, posY)
	$SubViewportContainer.position = Vector2(x, posY)
