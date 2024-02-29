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
	#var new_hat1 := hat.duplicate(true)
	#new_hat1.texture.set_atlas(cs.hats_spritesheet[1])
	#var new_hat2 := hat.duplicate(true)
	#new_hat2.texture.set_atlas(cs.hats_spritesheet[2])
	#items_catalogue["hats"][1] = new_hat1
	#items_catalogue["hats"][2] = new_hat2
	
	for hat_index: int in cs.hats_spritesheet:
		if (cs.hats_spritesheet[hat_index]):
			var new_hat := hat.duplicate(true)
			new_hat.texture.set_atlas(cs.hats_spritesheet[hat_index])
			items_catalogue["hats"][hat_index] = new_hat
	#for hat_texture_index: int in cs.hats_spritesheet:
		#print(hat_texture_index)
		#print(cs.hats_spritesheet[hat_texture_index])
		#if (cs.hats_spritesheet[hat_texture_index]):
			#var hat_copy: InventoryItemData = hat.duplicate()
			#hat_copy.texture.set_atlas(cs.hats_spritesheet[hat_texture_index])
			#hat_copy.name = str(cs.hats_spritesheet[hat_texture_index])
			##var path: String = cs.hats_spritesheet[hat_texture_index]
			##var atlas := load(path)
			##hat_item.init("hat", hat_texture_index, "Description", "hat", cs.hats_spritesheet[hat_texture_index], true)
			##hat_item.texture.set_atlas(atlas)
			##hat_item.texture.set_atlas(cs.hats_spritesheet[hat_texture_index])
#
			##hat.texture.set_atlas(cs.hats_spritesheet[hat_texture_index])
			#items_catalogue["hats"][hat_texture_index] = hat_copy
		
	
