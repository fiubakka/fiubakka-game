extends RichTextLabel


func _ready() -> void:
	text = Utils.center_text(tr("OPTION_CONTINUE"))


func _on_language_select_switch_locale() -> void:
	text = Utils.center_text(tr("OPTION_CONTINUE"))
