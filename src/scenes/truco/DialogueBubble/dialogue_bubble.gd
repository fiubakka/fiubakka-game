extends NinePatchRect

var text: RichTextLabel = null

func _ready() -> void:
	text = $RichTextLabel

func set_text(_text: String) -> void:
	text.set_text("[center]" + _text + "[/center]")
