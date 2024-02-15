extends Control

signal ui_opened(open: bool)
signal chat_visible(visible: bool)

var chat_focus: bool = false


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
			ui_opened.emit(false)
		else:
			chat.visible = true
			ui_opened.emit(true)


func handle_inventory_open() -> void:
	var menu := $GameMenu
	var pause := $Pause
	if !chat_focus and !pause.visible:
		if menu.visible:
			menu.visible = false
			ui_opened.emit(false)
		else:
			menu.visible = true
			ui_opened.emit(true)


func handle_pause_open() -> void:
	var pause := $Pause
	if pause.visible:
		pause.visible = false
		ui_opened.emit(false)
	else:
		pause.visible = true
		ui_opened.emit(true)


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus

