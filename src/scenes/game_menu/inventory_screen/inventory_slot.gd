extends TextureButton

class_name InventorySlot

var item : InventoryItemData = null
var is_focused : bool

func _ready() -> void:
	set_focus(false)


func update(_item: InventoryItemData) -> void:
	item = _item
	var sprite: Sprite2D = $CenterContainer/Panel/Sprite2D
	sprite.texture = item.texture
	print(sprite.texture)
	var availableSize: Vector2 = size * Vector2(0.7, 0.7)
	var scaleValue: float
	if item.texture.get_size().x > item.texture.get_size().y:
		scaleValue = availableSize.x / item.texture.get_size().x
	else:
		scaleValue = availableSize.y / item.texture.get_size().y
	sprite.scale = Vector2(scaleValue, scaleValue)


func set_focus(_is_focused: bool) -> void:
	is_focused = _is_focused
	if is_focused:
		modulate = Color(1, 1, 1)
	else:
		modulate = Color(0.5, 0.5, 0.5)

