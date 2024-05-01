extends Control

signal match_accepted(opponent_id: String)
signal match_rejected(opponent_id: String)

var opponent_id: String = ""

@onready var accept_button := $VBoxContainer/ButtonsContainer/Accept
@onready var reject_button := $VBoxContainer/ButtonsContainer/Reject
@onready var label := $VBoxContainer/RichTextLabel
@onready var player := $AudioStreamPlayer2D


func _on_server_consumer_truco_challenge_received(request_id: String) -> void:
	opponent_id = request_id
	label.text = Utils.center_text(opponent_id + tr("TRUCO_CHALLENGE"))
	visible = true
	$AnimationPlayer.play("drop_from_top")
	player.play()


func _on_accept_pressed() -> void:
	match_accepted.emit(opponent_id)
	visible = false


func _on_reject_pressed() -> void:
	match_rejected.emit(opponent_id)
	visible = false
