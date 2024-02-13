extends Control

signal player_can_move(can_move: bool)

var chat_focus: bool = false
var chat_open: bool = false
var inventory_open: bool = false

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_chat"):
		handle_chat_open()
	if Input.is_action_just_pressed("inventory"):
		handle_inventory_open()
	if Input.is_action_just_pressed("pause"):
		handle_pause_open()


func handle_chat_open() -> void:
	var chat := $Chatbox
	var menu := $GameMenu
	var pause := $Pause
	if !menu.visible and !pause.visible:
		if chat.visible:
			chat.visible = false
		else:
			chat.visible = true


func handle_inventory_open() -> void:
	var menu := $GameMenu
	var pause := $Pause
	if !chat_focus and !pause.visible:
		if menu.visible:
			menu.visible = false
		else:
			menu.visible = true


func handle_pause_open() -> void:
	var pause := $Pause
	if pause.visible:
		pause.visible = false
	else:
		pause.visible = true


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus
