extends RichTextLabel


func _on_login_error(errorCode: String) -> void:
	text = Utils.center_text(tr(errorCode))
	visible = true


func _on_return_to_menu() -> void:
	visible = false
