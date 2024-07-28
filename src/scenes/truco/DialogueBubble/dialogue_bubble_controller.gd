extends Control

var dialogue_bubble: NinePatchRect = null
var db_animation: AnimationPlayer = null

const PBTrucoShout = preload("res://addons/protocol/compiled/server/truco/play.gd").PBTrucoShout

const shouts_names = {
	PBTrucoShout.ENVIDO: "ENVIDO",
	PBTrucoShout.TRUCO: "TRUCO",
	PBTrucoShout.MAZO: "MAZO",
	PBTrucoShout.REAL_ENVIDO: "REAL_ENVIDO",
	PBTrucoShout.FALTA_ENVIDO: "FALTA_ENVIDO",
	PBTrucoShout.ENVIDO_QUIERO: "ENVIDO_QUIERO",
	PBTrucoShout.ENVIDO_NO_QUIERO: "ENVIDO_NO_QUIERO",
	PBTrucoShout.RETRUCO: "RETRUCO",
	PBTrucoShout.VALE_CUATRO: "VALE_CUATRO",
	PBTrucoShout.TRUCO_QUIERO: "TRUCO_QUIERO",
	PBTrucoShout.TRUCO_NO_QUIERO: "TRUCO_NO_QUIERO"
}


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_bubble = $DialogueBubble
	db_animation = $DialogueBubble/AnimationPlayer

	dialogue_bubble.modulate.a = 0


func show_shout(shout_id: int) -> void:
	if shout_id in shouts_names:
		show_dialogue(tr(shouts_names[shout_id]))


func show_dialogue(dialogue: String) -> void:
	dialogue_bubble.set_text(dialogue)
	db_animation.play("fade_out")
