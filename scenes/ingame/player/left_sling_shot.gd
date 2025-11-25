extends Node2D

@export var mirrored: bool = false
var collisionHandled = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func launchBody(body: Node2D, direction: Vector2) -> void:
	body.launch(Vector2(direction.x * 2500, direction.y * 2500))
	
func _on_upper_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("launch") && not collisionHandled:
		collisionHandled = true
		if mirrored:
			launchBody(body, Vector2(-1, -1))
		else:
			launchBody(body, Vector2(1, -1))


func _on_lower_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method("launch") && not collisionHandled:
		collisionHandled = true
		if mirrored:
			launchBody(body, Vector2(1, 1))
		else:
			launchBody(body, Vector2(-1, 1))


func _on_upper_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("launch"):
		collisionHandled = false


func _on_lower_area_2d_body_exited(body: Node2D) -> void:
	if body.has_method("launch"):
		collisionHandled = false
