extends Node

var items_catalogue := {}

var dni: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_dni.tres"
)

var hat: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_hat.tres"
)


func _ready() -> void:
	items_catalogue[0] = dni
	items_catalogue[1] = hat
	
