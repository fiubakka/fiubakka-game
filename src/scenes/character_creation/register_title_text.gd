extends RichTextLabel


func _ready() -> void:
	text = Utils.center_text(tr("CHAR_CREATION_TITLE"))


func _on_language_select_switch_locale() -> void:
	text = Utils.center_text(tr("CHAR_CREATION_TITLE"))
