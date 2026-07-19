class_name DamageIndicator extends Node2D

var currentHealth = 10.0
var maxHealth = 10.0
var textColor = Color(0.8, 0.0, 0.0)
var showDamage = false
var originalTextPosition = Vector2(0,0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$DamageText.hide()
	$HealthBar.hide()
	originalTextPosition = $DamageText.position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if showDamage:
		var modify = $DisplayDamageTimer.time_left / $DisplayDamageTimer.wait_time;
		var textSize = 2.0 - modify
		$DamageText.scale = Vector2(textSize, textSize)
		$DamageText.position = Vector2(originalTextPosition.x + ($DamageText.size.x * (modify - 1) / 2), originalTextPosition.y + ($DamageText.size.y * (modify - 1)))
		$DamageText.modulate = Color(textColor.r, textColor.g, textColor.b, modify);

func applyDamage(damage: float) -> void:
	currentHealth = currentHealth - damage
	$DamageText.text =  str(damage)
	$HealthBar.value = currentHealth 
	$DamageText.scale = Vector2(1, 1)
	$DamageText.position = originalTextPosition
	$DamageText.modulate = textColor
	$DamageText.show()
	$HealthBar.show()
	$DisplayDamageTimer.start()
	showDamage = true

func _on_display_damage_timer_timeout() -> void:
	showDamage = false
	$DamageText.hide()
	$HealthBar.hide()
	
