extends Node

signal send_message
signal is_focused(focus: bool)

var waiting_for_login: bool = true


func _process(_delta: float) -> void:
	if self.visible:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			var mouse_pos := get_viewport().get_mouse_position()
			var lineEdit := $LineEdit
			var pos: Vector2 = self.position
			var size: Vector2 = self.size
			if (
				(mouse_pos.x > pos.x + size.x or mouse_pos.x < pos.x)
				or (mouse_pos.y > pos.y + size.y or mouse_pos.y < pos.y)
			):
				lineEdit.release_focus()
				is_focused.emit(false)


func focus_chat() -> void:
	$LineEdit.grab_focus()


func _on_line_edit_send_message(message: String) -> void:
	send_message.emit(message)


func _on_server_consumer_update_content(entityId: String, content: String) -> void:
	$RichTextLabel.add_new_message(entityId, content)


func _on_main_login_ready() -> void:
	self.waiting_for_login = false


func _on_main_chat_opened() -> void:
	if !waiting_for_login:
		self.visible = true
		self.focus_chat()


func _on_main_chat_closed() -> void:
	if !waiting_for_login:
		self.visible = false


func _on_main_paused() -> void:
	if !waiting_for_login:
		self.visible = false


func _on_line_edit_focus_entered() -> void:
	is_focused.emit(true)


func _on_line_edit_focus_exited() -> void:
	is_focused.emit(false)
