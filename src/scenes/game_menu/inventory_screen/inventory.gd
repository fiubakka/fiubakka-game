extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]

var selected_slot: InventorySlot = null
var sprite : Node2D = null
var can_equip := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$VBoxContainer/Panel/EquipButton.visible = false
	get_inventory()
	sprite = $VBoxContainer/CenterContainer/Panel/CharacterSprite
	var slots := $ScrollContainer/GridContainer
	for i in range(0, len(Inventory)):
		var slot := inventory_slot_scene.instantiate()
		slot.update(Inventory[i])
		slot.pressed.connect(self._on_Slot_Pressed.bind(slot, Inventory[i]))
		slots.add_child(slot)


func get_inventory() -> void:
	# TODO: the server should tell this info and everytime you open the inventory
	var ic := ItemsCatalogue
	Inventory.append(ic.items_catalogue["miscellaneous"][0])
	Inventory.append(ic.items_catalogue["hats"][1])
	Inventory.append(ic.items_catalogue["hats"][2])
	Inventory.append(ic.items_catalogue["outfits"][2])


func handle_equip_button_availability() -> void:
	if (selected_slot):
		$VBoxContainer/Panel/EquipButton.visible = selected_slot.item.equippable


func handle_equip_button_text() -> void:
	if (selected_slot):
		var selected_item_texture := selected_slot.item.texture
		match selected_slot.item.type:
			"hat":
				change_equip_button_text(sprite.get_node("Hats"), selected_item_texture)
			"outfit":
				change_equip_button_text(sprite.get_node("Outfit"), selected_item_texture)
			"facial hair":
				change_equip_button_text(sprite.get_node("FacialHair"), selected_item_texture)
			"glasses":
				change_equip_button_text(sprite.get_node("Glasses"), selected_item_texture)
			"hair":
				change_equip_button_text(sprite.get_node("Hair"), selected_item_texture)


func change_equip_button_text(piece: Node2D, selected_item_texture: Texture) -> void:
	if (selected_item_texture.get_atlas() == piece.texture):
		$VBoxContainer/Panel/EquipButton.set_text("Unequip")
		can_equip = false
	else:
		$VBoxContainer/Panel/EquipButton.set_text("Equip")
		can_equip = true


func _on_Slot_Pressed(slot: InventorySlot, item: InventoryItemData) -> void:
	if item:
		if selected_slot:
			selected_slot.set_focus(false)
		selected_slot = slot
		selected_slot.set_focus(true)
		selected_slot = selected_slot
		handle_equip_button_availability()
		handle_equip_button_text()
		var name: RichTextLabel = $VBoxContainer/Description/VBoxContainer/Name
		name.clear()
		name.add_text(item.name)
		var description: RichTextLabel = $VBoxContainer/Description/VBoxContainer/Description
		description.clear()
		description.add_text(item.description)


func _on_button_pressed() -> void:
	if selected_slot and selected_slot.item.equippable:
		var selected_item_texture := selected_slot.item.texture
		match selected_slot.item.type:
			"hat":
				change_equipment(sprite.get_node("Hats"), selected_item_texture)
			"outfit":
				change_equipment(sprite.get_node("Outfit"), selected_item_texture)
			"facial hair":
				change_equipment(sprite.get_node("FacialHair"), selected_item_texture)
			"glasses":
				change_equipment(sprite.get_node("Glasses"), selected_item_texture)
			"hair":
				change_equipment(sprite.get_node("Hair"), selected_item_texture)
	handle_equip_button_text()
	#TODO: communication with the server


func change_equipment(body_part: Node2D, selected_item_texture: Texture) -> void:
	if can_equip:
		body_part.texture = selected_item_texture.get_atlas()
	else:
		body_part.texture = null

