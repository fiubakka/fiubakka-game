extends TextureRect

func update(item: InventoryItemData) -> void:
	$Sprite2D.texture = item.texture
	var availableSize: Vector2 = size * Vector2(0.9, 0.9)
	var scaleValue: float
	if item.texture.get_size().x > item.texture.get_size().y:
		scaleValue = availableSize.x / item.texture.get_size().x
	else:
		scaleValue = availableSize.y / item.texture.get_size().y
	$Sprite2D.scale = Vector2(scaleValue, scaleValue)
		
	
	
