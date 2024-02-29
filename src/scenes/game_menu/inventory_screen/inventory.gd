extends Control

@export var inventory_slot_scene: PackedScene

@export var Inventory: Array[InventoryItemData]
#@onready var slots: Array = $VBoxContainer/GridContainer.get_children()

@onready var dni: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_dni.tres"
)

@onready var hat: InventoryItemData = preload(
	"res://src/scenes/game_menu/inventory_screen/items/item_hat.tres"
)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Inventory.append(dni)
	#var cs := CompositeSprites
	#hat.texture.set_atlas(cs.hats_spritesheet[3])
	#Inventory.append(hat)
	var ic := ItemsCatalogue
	#print(ic.items_catalogue[1].texture)
	var sprite := $CharacterSprite/Hats
	#sprite.texture = ic.items_catalogue[0].texture.get_atlas()
	Inventory.append(ic.items_catalogue[0])
	Inventory.append(ic.items_catalogue[0])
	var slots := $ScrollContainer/GridContainer
	for i in range(0, len(Inventory)):
		var slot := inventory_slot_scene.instantiate()
		slot.update(Inventory[i])
		slot.pressed.connect(self._on_Slot_Pressed.bind(Inventory[i]))
		slots.add_child(slot)
		#var foo := slots.get_children()
		#foo[0].update(Inventory[0])
		


func _on_Slot_Pressed(item: InventoryItemData) -> void:
	print("oressed")
	if item:
		var name: RichTextLabel = $VBoxContainer/Panel/Description/VBoxContainer/Name
		name.add_text(item.name)
		var description: RichTextLabel = $VBoxContainer/Panel/Description/VBoxContainer/Description
		description.add_text(item.description)
