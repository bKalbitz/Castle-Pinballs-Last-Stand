extends Panel

const MAX_ENTRY_COUNT = 10
signal backToMenu
var scores: Array[Dictionary] = []
var submittedScore = 0
var submittedLevel = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func showScore() -> void:
	show()
	$VBoxContainer/SubmitVBoxContainer.hide()
	$VBoxContainer/BackButton.show()
	$VBoxContainer/BackButton.grab_focus.call_deferred()
	loadScores()
	renderScore()

func loadScores() -> void:
	scores = []
	for i in MAX_ENTRY_COUNT:
		var score = SimpleSettings.get_value("score", str(i, "_rank/score"), 0)
		if score > 0:
			var player = SimpleSettings.get_value("score", str(i, "_rank/player"), "")
			var level = SimpleSettings.get_value("score", str(i, "_rank/level"), "")
			scores.append({"score": score, "player": player, "level": level})

func renderScore() -> void:
	var vbox = $VBoxContainer/HighscoreVBoxContainer
	for c in vbox.get_children():
		c.queue_free();
	for s in scores:
		var label =  Label.new()
		label.text = str(s["score"], " - " , s["player"], " - " , s["level"])
		vbox.add_child(label)
	
func submitScore(levelName: String, score: int) -> void:
	showScore()
	$VBoxContainer/SubmitVBoxContainer/Label.text = str("Yor score:", score)
	$VBoxContainer/SubmitVBoxContainer/NameLineEdit.text = ""
	$VBoxContainer/SubmitVBoxContainer.show()
	if isHighScore(score):
		$VBoxContainer/SubmitVBoxContainer/NameLineEdit.show()
		$VBoxContainer/SubmitVBoxContainer/SubmitButton.show()
		$VBoxContainer/SubmitVBoxContainer/NameLineEdit.grab_focus.call_deferred()
		$VBoxContainer/BackButton.hide()
		submittedScore = score
		submittedLevel = levelName
		
	else:
		$VBoxContainer/SubmitVBoxContainer/NameLineEdit.hide()
		$VBoxContainer/SubmitVBoxContainer/SubmitButton.hide()
		$VBoxContainer/BackButton.show()
		$VBoxContainer/BackButton.grab_focus.call_deferred()
		submittedScore = 0
		submittedLevel = ""
	
func isHighScore(score: int) -> bool:
	if score < 1:
		return false
	return scores.size() < MAX_ENTRY_COUNT || scores[scores.size() - 1]["score"] < score

func _on_submit_button_button_down() -> void:
	$VBoxContainer/SubmitVBoxContainer.hide()
	if submittedScore < 1:
		return
	var player = $VBoxContainer/SubmitVBoxContainer/NameLineEdit.text
	if not player:
		player = "John Doe"
	var entry = {"score": submittedScore, "player": player, "level": submittedLevel}
	var newScores: Array[Dictionary] = []
	if scores.size() == 0:
		newScores.append(entry)
	else:
		for s in scores:
			if s["score"] > entry["score"]:
				newScores.append(s)
			else:
				newScores.append(entry)
				newScores.append(s)
	
	if newScores[newScores.size() - 1]["score"]  > entry["score"]:
		newScores.append(entry)
	
	if newScores.size() > MAX_ENTRY_COUNT:
		newScores.resize(MAX_ENTRY_COUNT)
	scores = newScores
	for i in scores.size():
		SimpleSettings.set_value("score", str(i, "_rank/score"), scores[i]["score"])
		SimpleSettings.set_value("score", str(i, "_rank/player"), scores[i]["player"])
		SimpleSettings.set_value("score", str(i, "_rank/level"), scores[i]["level"])
	SimpleSettings.save()
	renderScore()
	$VBoxContainer/BackButton.show()
	$VBoxContainer/BackButton.grab_focus.call_deferred()

func _on_back_button_pressed() -> void:
	backToMenu.emit()
