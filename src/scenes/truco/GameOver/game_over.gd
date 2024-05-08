extends Control

signal exit_truco

var text: RichTextLabel = null
var confetti: Confetti = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $CenterContainer/NinePatchRect/VBoxContainer/RichTextLabel
	confetti = $CenterContainer/Panel/Confetti


func set_victory() -> void:
	visible = true
	text.set_text(Utils.center_text("Victory!"))
	confetti.start()


func set_defeat() -> void:
	visible = true
	text.set_text(Utils.center_text("Defeat!"))


func _on_button_pressed() -> void:
	exit_truco.emit()
