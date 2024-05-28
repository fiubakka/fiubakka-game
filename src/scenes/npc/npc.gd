class_name NPC extends Node2D

enum Facing { FRONT, LEFT, RIGHT, BACK }

@export var npc_name: String
@export var actionable: bool = false
@export var message: String
@export var facing: Facing = Facing.FRONT

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
	$Name.text = Utils.center_text(npc_name)


func _physics_process(delta: float) -> void:
	if facing == Facing.FRONT:
		$AnimationPlayer.play("front")
	if facing == Facing.LEFT:
		$AnimationPlayer.play("left")
	if facing == Facing.BACK:
		$AnimationPlayer.play("back")
	if facing == Facing.RIGHT:
		$AnimationPlayer.play("right")


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
		
func get_equipment() -> Equipment:
	var equipment := Equipment.new()
	equipment.set_equipment(
		hat, hair, eyes, glasses, facial_hair, body, outfit
	)
	return equipment
