extends Control

var dialogue_bubble: NinePatchRect = null
var db_animation: AnimationPlayer = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	dialogue_bubble = $DialogueBubble
	db_animation = $DialogueBubble/AnimationPlayer

	dialogue_bubble.modulate.a = 0


func show_dialogue(dialogue: String) -> void:
	dialogue_bubble.set_text(dialogue)
	db_animation.play("fade_out")
