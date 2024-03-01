extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]

var selected_item :InventoryItemData = null

var sprite : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$EquipButton.visible = false
	get_inventory()
	sprite = $CharacterSprite
	var slots := $ScrollContainer/GridContainer
	for i in range(0, len(Inventory)):
		var slot := inventory_slot_scene.instantiate()
		slot.update(Inventory[i])
		slot.pressed.connect(self._on_Slot_Pressed.bind(Inventory[i]))
		slots.add_child(slot)


func get_inventory() -> void:
	# TODO: the server should tell this info and everytime you open the inventory
	var ic := ItemsCatalogue
	Inventory.append(ic.items_catalogue["miscellaneous"][0])
	Inventory.append(ic.items_catalogue["hats"][1])
	Inventory.append(ic.items_catalogue["hats"][2])


func equip_button_availability() -> void:
	if (selected_item):
		$EquipButton.visible = selected_item.equippable


func equip_button_text() -> void:
	if (selected_item):
		var selected_item_texture := selected_item.texture
		if (selected_item.type == "hat"):
			var hat := $CharacterSprite/Hats
			if (selected_item_texture.get_atlas() == hat.texture):
				$EquipButton.set_text("Unequip")
			else:
				$EquipButton.set_text("Equip")
			
			


func _on_Slot_Pressed(item: InventoryItemData) -> void:
	if item:
		selected_item = item
		equip_button_availability()
		equip_button_text()
		var name: RichTextLabel = $Panel/Description/VBoxContainer/Name
		name.clear()
		name.add_text(item.name)
		var description: RichTextLabel = $Panel/Description/VBoxContainer/Description
		description.clear()
		description.add_text(item.description)


func _on_button_pressed() -> void:
	if selected_item:
		if selected_item.equippable:
			if selected_item.type == "hat":
				var hat := $CharacterSprite/Hats
				print(selected_item.texture)
				hat.texture = selected_item.texture.get_atlas()
				#TODO: communication with the server
	equip_button_text()


