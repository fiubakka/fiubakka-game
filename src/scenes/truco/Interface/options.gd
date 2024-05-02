extends VBoxContainer

var available_shots := []
var available_answers_shots := []
const TrucoButtonScn := preload("res://src/scenes/truco/Interface/button.tscn")


func _ready() -> void:
	var shouts := {"shouts": ["ENVIDO"], "shout_answers": []}
	var isPlayCardAvailable := true
	set_available_shouts(isPlayCardAvailable, shouts)


func set_available_shouts(
	_isPlayCardAvailable: bool,
	_shouts: Dictionary
) -> void:
	clean()
	
	for shots: String in _shouts["shouts"]:
		var button: TrucoButton = TrucoButtonScn.instantiate()
		button.text = shots
		available_shots.append(button)
		if !_isPlayCardAvailable:
			button.disabled = true
		$AvailableShouts.add_child(button)
	
	for answer_shots: String in _shouts["shout_answers"]:
		var button: TrucoButton = TrucoButtonScn.instantiate()
		button.text = answer_shots
		available_answers_shots.append(button)
		$AvailableShoutAnswers.add_child(button)


func clean() -> void:
	for button: TrucoButton in available_shots:
		button.queue_free()
	
	for button: TrucoButton in available_answers_shots:
		button.queue_free()
