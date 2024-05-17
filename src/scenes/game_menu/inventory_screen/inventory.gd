extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]

var selected_slot: InventorySlot = null
var sprite: Node2D = null
var can_equip := false

signal update_equipment(equipment: Equipment)

@onready var equip_button := $HBoxContainer/VBoxContainer/Panel/EquipButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$HBoxContainer/VBoxContainer/Panel/EquipButton.visible = false
	get_inventory()
	sprite = $HBoxContainer/VBoxContainer/CenterContainer/Panel/CharacterSprite
	var slots := $HBoxContainer/ScrollContainer/GridContainer
	for i in range(0, len(Inventory)):
		var slot := inventory_slot_scene.instantiate()
		slot.update(Inventory[i])
		slot.pressed.connect(self._on_Slot_Pressed.bind(slot, Inventory[i]))
		slots.add_child(slot)
	
	equip_button.text = tr("EQUIP_BUTTON")


func get_inventory() -> void:
	# TODO: the server should tell this info and everytime you open the inventory
	var ic := ItemsCatalogue
	Inventory.append(ic.items_catalogue["miscellaneous"][0])
	Inventory.append(ic.items_catalogue["hats"][1])
	Inventory.append(ic.items_catalogue["hats"][2])
	Inventory.append(ic.items_catalogue["hats"][7])
	Inventory.append(ic.items_catalogue["hats"][3])
	Inventory.append(ic.items_catalogue["outfits"][2])
	Inventory.append(ic.items_catalogue["outfits"][3])
	Inventory.append(ic.items_catalogue["hairs"][1])
	Inventory.append(ic.items_catalogue["hairs"][2])
	Inventory.append(ic.items_catalogue["glasses"][3])
	Inventory.append(ic.items_catalogue["glasses"][2])
	Inventory.append(ic.items_catalogue["glasses"][2])
	Inventory.append(ic.items_catalogue["facial hair"][2])
	Inventory.append(ic.items_catalogue["facial hair"][4])


func handle_equip_button_availability() -> void:
	if selected_slot:
		$HBoxContainer/VBoxContainer/Panel/EquipButton.visible = selected_slot.item.equippable


func handle_equip_button_text() -> void:
	if selected_slot:
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
	if selected_item_texture.get_atlas() == piece.texture:
		$HBoxContainer/VBoxContainer/Panel/EquipButton.set_text(tr("UNEQUIP_BUTTON"))
		can_equip = false
	else:
		$HBoxContainer/VBoxContainer/Panel/EquipButton.set_text(tr("EQUIP_BUTTON"))
		can_equip = true


func _on_Slot_Pressed(slot: InventorySlot, item: InventoryItemData) -> void:
	if item:
		if selected_slot:
			selected_slot.set_focus(false)
		selected_slot = slot
		selected_slot.set_focus(true)
		handle_equip_button_availability()
		handle_equip_button_text()
		var name: RichTextLabel = $HBoxContainer/VBoxContainer/Description/VBoxContainer/Name
		name.clear()
		name.add_text(item.name)
		var description: RichTextLabel = $HBoxContainer/VBoxContainer/Description/VBoxContainer/Description
		description.clear()
		description.add_text(item.description)


func _on_button_pressed() -> void:
	var player: Player = get_tree().current_scene.get_node("Player")
	var newEquipment := Equipment.new()
	(
		newEquipment
		. set_equipment(
			player.equipment.hat,
			player.equipment.hair,
			player.equipment.eyes,
			player.equipment.glasses,
			player.equipment.facial_hair,
			player.equipment.body,
			player.equipment.outfit,
		)
	)

	if selected_slot and selected_slot.item.equippable:
		var selected_item_texture := selected_slot.item.texture
		var selected_item_id := selected_slot.item.id
		match selected_slot.item.type:
			"hat":
				change_equipment(sprite.get_node("Hats"), selected_item_texture)
				newEquipment.set_hat(selected_item_id if can_equip else 0)
			"outfit":
				change_equipment(sprite.get_node("Outfit"), selected_item_texture)
				newEquipment.set_outfit(selected_item_id if can_equip else 0)
			"facial hair":
				change_equipment(sprite.get_node("FacialHair"), selected_item_texture)
				newEquipment.set_facial_hair(selected_item_id if can_equip else 0)
			"glasses":
				change_equipment(sprite.get_node("Glasses"), selected_item_texture)
				newEquipment.set_glasses(selected_item_id if can_equip else 0)
			"hair":
				change_equipment(sprite.get_node("Hair"), selected_item_texture)
				newEquipment.set_hair(selected_item_id if can_equip else 0)
	handle_equip_button_text()
	player.set_equipment(newEquipment)
	PlayerInfo.player_customization = PlayerInfo.from_equipment(newEquipment)
	update_equipment.emit(newEquipment)


func change_equipment(body_part: Node2D, selected_item_texture: Texture) -> void:
	if can_equip:
		body_part.texture = selected_item_texture.get_atlas()
	else:
		body_part.texture = null
		#TODO: Ver caso del Outfit, para hacer que se le setee un outfit default
		#en vez de quedar desnudo


func _on_server_consumer_user_init_ready(
	_position: Vector2, equipment: Equipment, mapId: int
) -> void:
	var cs := CompositeSprites
	can_equip = true
	sprite.get_node("Hair").texture = cs.hair_spritesheet[equipment.hair]
	sprite.get_node("Hats").texture = cs.hats_spritesheet[equipment.hat]
	sprite.get_node("Body").texture = cs.body_spritesheet[equipment.body]
	sprite.get_node("Outfit").texture = cs.outfit_spritesheet[equipment.outfit]
	sprite.get_node("FacialHair").texture = cs.facial_hair_spritesheet[equipment.facial_hair]
	sprite.get_node("Glasses").texture = cs.glasses_spritesheet[equipment.glasses]
	sprite.get_node("Eyes").texture = cs.eyes_spritesheet[equipment.eyes]
	can_equip = false
