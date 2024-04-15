extends Control

signal ui_opened(open: bool)
signal chat_visible(visible: bool)

var chat_focus: bool = false

var chat: Control
var menu: Control
var pause: Control


func _ready() -> void:
	self.set_process(false)
	chat = $Chatbox
	menu = $GameMenu
	pause = $Pause


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_chat"):
		handle_chat_open()
	if Input.is_action_just_pressed("inventory"):
		handle_inventory_open()
	if Input.is_action_just_pressed("pause"):
		handle_pause_open()


func handle_chat_open() -> void:
	if !menu.visible or !pause.visible:
		chat.visible = !chat.visible
		var isVisible: bool = chat.visible or menu.visible or pause.visible
		ui_opened.emit(isVisible)


func handle_inventory_open() -> void:
	if !chat_focus and !pause.visible:
		menu.visible = !menu.visible
		var isVisible: bool = chat.visible or menu.visible or pause.visible
		ui_opened.emit(isVisible)


func handle_pause_open() -> void:
	pause.visible = !pause.visible
	var isVisible: bool = chat.visible or menu.visible or pause.visible
	ui_opened.emit(isVisible)


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus
