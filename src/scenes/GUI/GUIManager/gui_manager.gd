extends Control

signal ui_opened(open: bool)
signal chat_visible(visible: bool)

var chat_focus: bool = false

var chat: Control
var menu: Control
var pause: Control
var npc_tip: Control


func _ready() -> void:
	self.set_process(false)
	chat = $Chatbox
	menu = $GameMenu
	pause = $Pause
	npc_tip = $NpcTip


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
		var visible: bool = chat.visible or menu.visible or pause.visible
		ui_opened.emit(visible)


func handle_inventory_open() -> void:
	if !chat_focus and !pause.visible:
		menu.visible = !menu.visible
		var visible: bool = chat.visible or menu.visible or pause.visible
		ui_opened.emit(visible)


func handle_pause_open() -> void:
	pause.visible = !pause.visible
	var visible: bool = chat.visible or menu.visible or pause.visible
	ui_opened.emit(visible)


func _on_chatbox_is_focused(focus: bool) -> void:
	chat_focus = focus

func _on_npc_tip(message: String) -> void:
	npc_tip.show_tip(message)
