extends Node2D

@export var id := 1
var velocity := Vector2(0, 0)
var prev_vel := Vector2(0, 0)
var player_name := ""
var equipment: Equipment

var cs := CompositeSprites


func _ready() -> void:
	$Name.text = Utils.center_text("[color=#ffaaaa]" + player_name + "[/color]")

	# Set idle front animation when spawning player
	set_idle_region()
	$AnimationPlayer.play("front")


func set_equipment(new_equipment: Equipment) -> void:
	equipment = new_equipment
	$EntitySprite/Hats.texture = cs.hats_spritesheet[new_equipment["hat"]]
	$EntitySprite/Hair.texture = cs.hair_spritesheet[new_equipment["hair"]]
	$EntitySprite/Eyes.texture = cs.eyes_spritesheet[new_equipment["eyes"]]
	$EntitySprite/Body.texture = cs.body_spritesheet[new_equipment["body"]]
	$EntitySprite/Glasses.texture = cs.glasses_spritesheet[new_equipment["glasses"]]
	$EntitySprite/FacialHair.texture = cs.facial_hair_spritesheet[new_equipment["facial_hair"]]
	$EntitySprite/Outfit.texture = cs.outfit_spritesheet[new_equipment["outfit"]]


func _process(_delta: float) -> void:
	if prev_vel == velocity:
		return

	set_walk_region()
	if velocity.x > 0:
		$AnimationPlayer.play("right")
	elif velocity.x < 0:
		$AnimationPlayer.play("left")
	elif velocity.y < 0:
		$AnimationPlayer.play("back")
	elif velocity.y > 0:
		$AnimationPlayer.play("front")
	else:
		set_idle_region()
		if prev_vel.x > 0:
			$AnimationPlayer.play("right")
		elif prev_vel.x < 0:
			$AnimationPlayer.play("left")
		elif prev_vel.y < 0:
			$AnimationPlayer.play("back")
		elif prev_vel.y > 0:
			$AnimationPlayer.play("front")

	prev_vel = velocity


func set_idle_region() -> void:
	var idle_region_rect := Rect2(0, 120, 1152, 72)
	$EntitySprite/Body.region_rect = idle_region_rect
	$EntitySprite/Hair.region_rect = idle_region_rect
	$EntitySprite/Eyes.region_rect = idle_region_rect
	$EntitySprite/Outfit.region_rect = idle_region_rect
	$EntitySprite/FacialHair.region_rect = idle_region_rect
	$EntitySprite/Glasses.region_rect = idle_region_rect
	$EntitySprite/Hats.region_rect = Rect2(0, 96, 1152, 72)


func set_walk_region() -> void:
	var walk_region_rect := Rect2(0, 216, 1152, 72)
	$EntitySprite/Body.region_rect = walk_region_rect
	$EntitySprite/Hair.region_rect = walk_region_rect
	$EntitySprite/Eyes.region_rect = walk_region_rect
	$EntitySprite/Outfit.region_rect = walk_region_rect
	$EntitySprite/FacialHair.region_rect = walk_region_rect
	$EntitySprite/Glasses.region_rect = walk_region_rect
	$EntitySprite/Hats.region_rect = Rect2(0, 190, 1152, 72)
