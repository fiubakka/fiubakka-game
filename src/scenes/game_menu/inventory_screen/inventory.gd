extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]

var selected_item :InventoryItemData = null

var sprite : Node2D = null

var can_equip := false

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
	Inventory.append(ic.items_catalogue["outfits"][2])


func handle_equip_button_availability() -> void:
	if (selected_item):
		$EquipButton.visible = selected_item.equippable


func handle_equip_button_text() -> void:
	if (selected_item):
		var selected_item_texture := selected_item.texture
		match selected_item.type:
			"hat":
				change_equip_button_text($CharacterSprite/Hats, selected_item_texture)
			"outfit":
				change_equip_button_text($CharacterSprite/Outfit, selected_item_texture)
			"facial hair":
				change_equip_button_text($CharacterSprite/FacialHair, selected_item_texture)
			"glasses":
				change_equip_button_text($CharacterSprite/Glasses, selected_item_texture)
			"hair":
				change_equip_button_text($CharacterSprite/Hair, selected_item_texture)


func change_equip_button_text(piece: Node2D, selected_item_texture: Texture) -> void:
	if (selected_item_texture.get_atlas() == piece.texture):
		$EquipButton.set_text("Unequip")
		can_equip = false
	else:
		$EquipButton.set_text("Equip")
		can_equip = true


func _on_Slot_Pressed(item: InventoryItemData) -> void:
	if item:
		selected_item = item
		handle_equip_button_availability()
		handle_equip_button_text()
		var name: RichTextLabel = $Panel/Description/VBoxContainer/Name
		name.clear()
		name.add_text(item.name)
		var description: RichTextLabel = $Panel/Description/VBoxContainer/Description
		description.clear()
		description.add_text(item.description)


func _on_button_pressed() -> void:
	if selected_item and selected_item.equippable:
		var selected_item_texture := selected_item.texture
		match selected_item.type:
			"hat":
				change_equipment($CharacterSprite/Hats, selected_item_texture)
			"outfit":
				change_equipment($CharacterSprite/Outfit, selected_item_texture)
			"facial hair":
				change_equipment($CharacterSprite/FacialHair, selected_item_texture)
			"glasses":
				change_equipment($CharacterSprite/Glasses, selected_item_texture)
			"hair":
				change_equipment($CharacterSprite/Hair, selected_item_texture)
	handle_equip_button_text()
	#TODO: communication with the server


func change_equipment(body_part: Node2D, selected_item_texture: Texture) -> void:
	if can_equip:
		body_part.texture = selected_item_texture.get_atlas()
	else:
		body_part.texture = null

