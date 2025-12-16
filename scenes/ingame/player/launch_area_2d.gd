class_name LaunchArea extends Area2D

const MAX = 1.0
const IMPULSE_Y = -5000
var ball
var power = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func getWidth() -> float:
	return $ProgressBar.position.x + $ProgressBar.size.x + 5

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ProgressBar.value = power * 100
	if Input.is_action_pressed("ball_action"):
		if power < MAX:
			power = power + delta
		if power > MAX:
			power = MAX
	else:
		if power > 0 && ball && ball.has_method("launch"):
			$ShootSound.play()
			var impulse = Vector2(0, IMPULSE_Y * power)
			ball.launch(impulse)
			$CannonFireParticle.restart()
		power = 0

func _on_body_entered(body: Node2D) -> void:
	if body.has_method("launch") && "inLauncArea" in body:
		ball = body
		ball.inLauncArea = true

func _on_body_exited(body: Node2D) -> void:
	if body.has_method("launch") && "inLauncArea" in body:
		ball.inLauncArea = false
		ball = null
