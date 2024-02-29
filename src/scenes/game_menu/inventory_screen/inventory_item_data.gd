extends Resource

class_name InventoryItemData

@export var name: String
@export var id: int
@export var description: String
@export var type: String
@export var texture: Texture2D
@export var equippable: bool

func init(_name: String, _id: int,
_description: String, _type: String,
_texture: Texture, _equippable: bool) -> void:
	self.name = _name
	self.id = _id
	self.description = _description
	self.type = _type
	self.texture = _texture
	self.equippable = _equippable
