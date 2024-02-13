extends Control

signal open_chat(open: bool)
signal player_can_move(can_move: bool)

var chat_focus: bool = false
var chat_open: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("open_chat"):
		handle_chat_open()

func handle_chat_open() -> void:
	if !chat_focus:
		if chat_open:
			open_chat.emit(false)
			chat_open = false
		else:
			open_chat.emit(true)
			chat_open = true


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus
