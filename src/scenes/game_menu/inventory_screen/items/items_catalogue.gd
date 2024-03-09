extends Node

var cs := CompositeSprites

var items_catalogue := {
	"miscellaneous": {},
	"hats": {},
	"outfits": {},
	"hairs": {},
	"facial hair": {},
	"glasses": {}
}

var dni: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_dni.tres"
)

var hat: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_hat.tres"
)

var outfit: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_outfit.tres"
)

var hair: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_hair.tres"
)

var facial_hair: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_facial_hair.tres"
)

var glasses: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_glasses.tres"
)


func _ready() -> void:
	# miscellaneous
	items_catalogue["miscellaneous"][0] = dni
	
	create_resources("hats", hat, cs.hats_spritesheet)
	create_resources("outfits", outfit, cs.outfit_spritesheet)
	create_resources("hairs", hair, cs.hair_spritesheet)
	create_resources("facial hair", facial_hair, cs.facial_hair_spritesheet)
	create_resources("glasses", glasses, cs.glasses_spritesheet)


func create_resources(type: String, original_res: InventoryItemData, texture_dic: Dictionary) -> void:
	for index: int in texture_dic:
		create_new_resource(index, type, original_res, texture_dic)


func create_new_resource(index: int, type: String, original_res: InventoryItemData, texture_dic: Dictionary) -> void:
	if (texture_dic[index]):
		var new_res := original_res.duplicate(true)
		new_res.texture.set_atlas(texture_dic[index])
		items_catalogue[type][index] = new_res

