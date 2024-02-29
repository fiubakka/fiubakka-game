extends Node

var cs := CompositeSprites

var items_catalogue := {
	"miscellaneous": {},
	"hats": {}
}

var dni: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_dni.tres"
)

var hat: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_hat.tres"
)


func _ready() -> void:
	# miscellaneous
	items_catalogue["miscellaneous"][0] = dni
	
	# hats
	for hat_index: int in cs.hats_spritesheet:
		if (cs.hats_spritesheet[hat_index]):
			var new_hat := hat.duplicate(true)
			new_hat.texture.set_atlas(cs.hats_spritesheet[hat_index])
			items_catalogue["hats"][hat_index] = new_hat
