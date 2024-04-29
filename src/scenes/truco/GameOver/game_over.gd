extends Control

var text: RichTextLabel = null
var confetti: Confetti = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $CenterContainer/NinePatchRect/VBoxContainer/RichTextLabel
	confetti = $CenterContainer/Panel/Confetti
	set_victory()


func set_victory() -> void:
	text.set_text(Utils.center_text("Victory!"))
	confetti.start()


func set_defeat() -> void:
	text.set_text(Utils.center_text("Defeat!"))
