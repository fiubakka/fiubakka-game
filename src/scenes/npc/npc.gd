class_name NPC extends Node2D

@export var actionable: bool = false
@export var message: String

@export var body: int
@export var hair: int
@export var hat: int
@export var eyes: int
@export var outfit: int
@export var facial_hair: int
@export var glasses: int

@onready var sprite := $NpcSprite

var _cs := CompositeSprites

func _ready() -> void:
	$NpcSprite/Body.texture = _cs.body_spritesheet[body]
	$NpcSprite/Hair.texture = _cs.hair_spritesheet[hair]
	$NpcSprite/Hats.texture = _cs.hats_spritesheet[hat]
	$NpcSprite/Eyes.texture = _cs.eyes_spritesheet[eyes]
	$NpcSprite/Outfit.texture = _cs.outfit_spritesheet[outfit]
	$NpcSprite/FacialHair.texture = _cs.facial_hair_spritesheet[facial_hair]
	$NpcSprite/Glasses.texture = _cs.glasses_spritesheet[glasses]


func _on_area_2d_body_entered(player: Node2D) -> void:
	if not player is Player:
		return
	$Icon.visible = true
	actionable = true
	player.npc = self
	

func _on_area_2d_body_exited(player: Node2D) -> void:
	if not player is Player:
		return
	$Icon.visible = false
	actionable = false
	if player.npc == self:
		player.npc = null

