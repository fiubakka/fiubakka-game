extends Control

var text: RichTextLabel = null
var confetti: Confetti = null

signal exit_button_pressed
signal opponent_abandoned


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = $CenterContainer/NinePatchRect/VBoxContainer/RichTextLabel
	confetti = $CenterContainer/Panel/Confetti


func set_match_result(my_points: int, opponent_points: int) -> void:
	visible = true
	if my_points == opponent_points:
		set_tie()
	elif my_points > opponent_points:
		set_victory()
	else:
		set_defeat()


func set_tie() -> void:
	text.set_text(Utils.center_text(tr("TRUCO_TIE")))


func set_victory() -> void:
	text.set_text(Utils.center_text(tr("TRUCO_VICTORY")))
	confetti.start()


func set_defeat() -> void:
	text.set_text(Utils.center_text(tr("TRUCO_DEFEAT")))


func _on_button_pressed() -> void:
	exit_button_pressed.emit()


func _on_truco_manager_opponent_abandoned() -> void:
	visible = true
	set_victory()
	opponent_abandoned.emit()
