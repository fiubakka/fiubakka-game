extends NinePatchRect

var text: RichTextLabel = null


func _ready() -> void:
	text = $RichTextLabel


func set_text(_text: String) -> void:
	text.set_text(Utils.center_text(_text))
