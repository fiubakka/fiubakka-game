extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]

var selected_item :InventoryItemData = null

var sprite : Node2D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite = $CharacterSprite
	#Inventory.append(dni)
	#var cs := CompositeSprites
	#hat.texture.set_atlas(cs.hats_spritesheet[3])
	#Inventory.append(hat)
	var ic := ItemsCatalogue
	#print(ic.items_catalogue[1].texture)
	#var sprite := $CharacterSprite/Hats
	#sprite.texture = ic.items_catalogue[0].texture.get_atlas()
	Inventory.append(ic.items_catalogue["hats"][1])
	Inventory.append(ic.items_catalogue["hats"][2])
	var slots := $ScrollContainer/GridContainer
	for i in range(0, len(Inventory)):
		var slot := inventory_slot_scene.instantiate()
		slot.update(Inventory[i])
		slot.pressed.connect(self._on_Slot_Pressed.bind(Inventory[i]))
		slots.add_child(slot)
		#var foo := slots.get_children()
		#foo[0].update(Inventory[0])
		


func _on_Slot_Pressed(item: InventoryItemData) -> void:
	if item:
		selected_item = item
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
			
