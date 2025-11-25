class_name  SateEffect extends Object

var effectId: String

var duration: float = 1.0
var effects: String = "enemy"
var damageOverTime: float = 0.0
var speedEffect: float = 1.0
var colorChange: Color = Color(1, 1, 1, 1)

var activeTime: float
var active: bool = true

func _init(_effectId: String) -> void:
	effectId = effectId

func process(delta: float) -> bool:
	activeTime = activeTime + delta
	active = activeTime < duration
	return active

func getColorChange(colorBefore: Color) -> Color:
	if colorChange == Color.WHITE:
		return colorBefore
	return colorBefore.blend(colorChange)

func equal(compare: SateEffect) -> bool:
	return effectId == compare.effectId
	
func updateData(data: SateEffect) -> void:
	effectId = data.effectId
	duration = data.duration
	effects = data.effects
	damageOverTime = data.damageOverTime
	speedEffect = data.speedEffect
	colorChange = data.colorChange
	activeTime = data.activeTime
	active = data.active
