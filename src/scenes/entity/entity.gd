extends Node2D

@export var id := 1
var velocity := Vector2(0, 0)
var prev_vel := Vector2(0, 0)
var player_name := ""

var cs := CompositeSprites


func _ready() -> void:
	$Name.text = Utils.center_text("[color=#ffaaaa]" + player_name + "[/color]")

	var customization := random_character()
	$EntitySprite/Hats.texture = cs.hats_spritesheet[customization["hats"]]
	$EntitySprite/Hair.texture = cs.hair_spritesheet[customization["hair"]]
	$EntitySprite/Eyes.texture = cs.eyes_spritesheet[customization["eyes"]]
	$EntitySprite/Body.texture = cs.body_spritesheet[customization["body"]]
	$EntitySprite/Glasses.texture = cs.glasses_spritesheet[customization["glasses"]]
	$EntitySprite/FacialHair.texture = cs.facial_hair_spritesheet[customization["facial_hair"]]
	$EntitySprite/Outfit.texture = cs.outfit_spritesheet[customization["outfit"]]

	# Set idle front animation when spawning player
	set_idle_region()
	$AnimationPlayer.play("front")


# TODO: this is for local testing only
# Remove this method and use the data in the message
# received from the server
func random_character() -> Dictionary:
	var rng := RandomNumberGenerator.new()
	return {
		"hats": rng.randi_range(0, cs.hats_spritesheet.size() - 1),
		"hair": rng.randi_range(0, cs.hair_spritesheet.size() - 1),
		"eyes": rng.randi_range(0, cs.eyes_spritesheet.size() - 1),
		"glasses": rng.randi_range(0, cs.glasses_spritesheet.size() - 1),
		"facial_hair": rng.randi_range(0, cs.facial_hair_spritesheet.size() - 1),
		"body": rng.randi_range(0, cs.body_spritesheet.size() - 1),
		"outfit": rng.randi_range(0, cs.outfit_spritesheet.size() - 1)
	}


func set_equipment(equipment: Equipment) -> void:
	$EntitySprite/Hats.texture = cs.hats_spritesheet[equipment["hat"]]
	$EntitySprite/Hair.texture = cs.hair_spritesheet[equipment["hair"]]
	$EntitySprite/Eyes.texture = cs.eyes_spritesheet[equipment["eyes"]]
	$EntitySprite/Body.texture = cs.body_spritesheet[equipment["body"]]
	$EntitySprite/Glasses.texture = cs.glasses_spritesheet[equipment["glasses"]]
	$EntitySprite/FacialHair.texture = cs.facial_hair_spritesheet[equipment["facial_hair"]]
	$EntitySprite/Outfit.texture = cs.outfit_spritesheet[equipment["outfit"]]


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
