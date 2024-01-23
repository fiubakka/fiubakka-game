extends Control

@export var Inventory: Array[InventoryItemData]
@onready var slots: Array = $VBoxContainer/GridContainer.get_children()

@onready var dni: InventoryItemData = preload("res://src/scenes/game_menu/inventory_screen/items/item_dni.tres")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Inventory.append(dni)
	for i in range(0, len(Inventory)):
		slots[i].update(Inventory[i])
		slots[i].pressed.connect(self._on_Slot_Pressed.bind(Inventory[i]))
	
func _on_Slot_Pressed(item: InventoryItemData) -> void:
	if (item):
		var name: RichTextLabel = $VBoxContainer/Panel/Description/VBoxContainer/Name
		name.add_text(item.name)
		var description: RichTextLabel = $VBoxContainer/Panel/Description/VBoxContainer/Description
		description.add_text(item.description)
