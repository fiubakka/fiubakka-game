extends Control

@export var Inventory: Array[InventoryItemData]
@onready var slots: Array = $VBoxContainer/GridContainer.get_children()

@onready var dni: InventoryItemData = preload("res://src/scenes/game_menu/inventory_screen/items/item_dni.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slots[0].update(dni)


