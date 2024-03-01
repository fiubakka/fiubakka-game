extends Control

signal ui_opened(open: bool)
signal chat_visible(visible: bool)

var chat_focus: bool = false


func _ready() -> void:
	self.set_process(false)


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
	if !menu.visible or !pause.visible:
		chat.visible = !chat.visible
		ui_opened.emit(chat.visible)


func handle_inventory_open() -> void:
	var menu := $GameMenu
	var pause := $Pause
	if !chat_focus and !pause.visible:
		menu.visible = !menu.visible
		ui_opened.emit(menu.visible)


func handle_pause_open() -> void:
	var pause := $Pause
	print(pause.visible)
	pause.visible = !pause.visible
	ui_opened.emit(pause.visible)


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus

