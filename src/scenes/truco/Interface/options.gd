extends VBoxContainer

class_name Options

signal shout_played(shout_id: int)

var available_shots := []
var available_answers_shots := []

const TrucoButtonScn := preload("res://src/scenes/truco/Interface/button.tscn")
const PBTrucoShout = (
	preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoShout
)

const shouts_names = {
	PBTrucoShout.ENVIDO: "ENVIDO",
	PBTrucoShout.TRUCO: "TRUCO",
	PBTrucoShout.MAZO: "MAZO"
}
	
const shouts_aswers_names = {
	PBTrucoShout.REAL_ENVIDO: "REAL ENVIDO",
	PBTrucoShout.FALTA_ENVIDO: "FALTA ENVIDO",
	PBTrucoShout.ENVIDO_QUIERO: "ENVIDO QUIERO",
	PBTrucoShout.ENVIDO_NO_QUIERO: "ENVIDO NO QUIERO",
	PBTrucoShout.RETRUCO: "RETRUCO",
	PBTrucoShout.VALE_CUATRO: "VALE CUATRO",
	PBTrucoShout.TRUCO_QUIERO: "TRUCO QUIERO",
	PBTrucoShout.TRUCO_NO_QUIERO: "TRUCO NO QUIERO"
}

func _ready() -> void:
	pass


func set_available_shouts(
	_isPlayCardAvailable: bool,
	_shouts: Array
) -> void:
	clean()
	
	for shout: int in _shouts:
		if shout not in shouts_names and shout not in shouts_aswers_names:
			continue
		var shout_name := ""
		var button: TrucoButton = TrucoButtonScn.instantiate()
		if shout in shouts_names:
			available_shots.append(button)
			shout_name = shouts_names[shout]
			button.disabled = !_isPlayCardAvailable
			$AvailableShouts.add_child(button)
		else:
			available_answers_shots.append(button)
			shout_name = shouts_aswers_names[shout]
			$AvailableShoutAnswers.add_child(button)
		button.text = shout_name
		button.pressed.connect(self._on_button_truco_pressed.bind(shout))


func _on_button_truco_pressed(shout_id: int) -> void:
	shout_played.emit(shout_id)


func clean() -> void:
	for button: TrucoButton in available_shots:
		button.queue_free()
	available_shots = []
	
	for button: TrucoButton in available_answers_shots:
		button.queue_free()
	available_answers_shots = []


func disable_buttons(is_disable: bool) -> void:
	for button: TrucoButton in available_shots:
		button.disabled = is_disable
	
	for button: TrucoButton in available_answers_shots:
		button.disabled = is_disable
