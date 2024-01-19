extends TextureRect

func update(item: InventoryItemData) -> void:
	var sprite: Sprite2D = $CenterContainer/Panel/Sprite2D
	sprite.texture = item.texture
	var availableSize: Vector2 = size * Vector2(0.7, 0.7)
	var scaleValue: float
	if item.texture.get_size().x > item.texture.get_size().y:
		scaleValue = availableSize.x / item.texture.get_size().x
	else:
		scaleValue = availableSize.y / item.texture.get_size().y
	sprite.scale = Vector2(scaleValue, scaleValue)
		
	
	
