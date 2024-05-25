extends Node2D

var _cs := CompositeSprites


func _on_dialogue_show_npc_tip(_name: String, _message: String, equipment: Equipment) -> void:
	$Body.texture = _cs.body_spritesheet[equipment.body]
	$Hair.texture = _cs.hair_spritesheet[equipment.hair]
	$Hats.texture = _cs.hats_spritesheet[equipment.hat]
	$Eyes.texture = _cs.eyes_spritesheet[equipment.eyes]
	$Outfit.texture = _cs.outfit_spritesheet[equipment.outfit]
	$FacialHair.texture = _cs.facial_hair_spritesheet[equipment.facial_hair]
	$Glasses.texture = _cs.glasses_spritesheet[equipment.glasses]
