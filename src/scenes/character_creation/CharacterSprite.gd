extends Node2D

@onready
var body_sprite := $CompositeSprites/Body
@onready
var hair_sprite := $CompositeSprites/Hair
@onready
var eyes_sprite := $CompositeSprites/Eyes
@onready
var outfit_sprite := $CompositeSprites/Outfit
@onready
var facial_hair_sprite := $CompositeSprites/FacialHair
@onready
var glasses_sprite := $CompositeSprites/Glasses
@onready
var hats_sprite := $CompositeSprites/Hats

const cs = preload("res://src/scenes/character_creation/CompositeSprites.gd")
var rng := RandomNumberGenerator.new()
var body_idx := rng.randi_range(0, cs.body_spritesheet.size() - 1)
var hair_idx := rng.randi_range(0, cs.hair_spritesheet.size() - 1)
var eyes_idx := rng.randi_range(0, cs.eyes_spritesheet.size() - 1)
var outfit_idx := rng.randi_range(0, cs.outfit_spritesheet.size() - 1)
var facial_hair_idx := rng.randi_range(0, cs.facial_hair_spritesheet.size() - 1)
var glasses_idx := rng.randi_range(0, cs.glasses_spritesheet.size() - 1)
var hats_idx := rng.randi_range(0, cs.hats_spritesheet.size() - 1)


func _ready() -> void:
	body_sprite.texture = cs.body_spritesheet[body_idx]
	hair_sprite.texture = cs.hair_spritesheet[hair_idx]
	eyes_sprite.texture = cs.eyes_spritesheet[eyes_idx]
	outfit_sprite.texture = cs.outfit_spritesheet[0]
	facial_hair_sprite.texture = cs.facial_hair_spritesheet[0]
	glasses_sprite.texture = cs.glasses_spritesheet[0]
	hats_sprite.texture = cs.hats_spritesheet[0]
	
# Body
func _on_body_select_next() -> void:
	body_idx += 1
	if body_idx == cs.body_spritesheet.size():
		body_idx = 0
	body_sprite.texture = cs.body_spritesheet[body_idx]
	
func _on_body_select_prev() -> void:
	body_idx -= 1
	if body_idx < 0:
		body_idx = cs.body_spritesheet.size() - 1
	body_sprite.texture = cs.body_spritesheet[body_idx]

# Eyes
func _on_eyes_select_next() -> void:
	eyes_idx += 1
	if eyes_idx == cs.eyes_spritesheet.size():
		eyes_idx = 0
	eyes_sprite.texture = cs.eyes_spritesheet[eyes_idx]
	
func _on_eyes_select_prev() -> void:
	eyes_idx -= 1
	if eyes_idx < 0:
		eyes_idx = cs.eyes_spritesheet.size() - 1
	eyes_sprite.texture = cs.eyes_spritesheet[eyes_idx]
	

# Hair
func _on_hair_select_next() -> void:
	hair_idx += 1
	if hair_idx == cs.hair_spritesheet.size():
		hair_idx = 0
	hair_sprite.texture = cs.hair_spritesheet[hair_idx]


func _on_hair_select_prev() -> void:
	hair_idx -= 1
	if hair_idx < 0:
		hair_idx = cs.hair_spritesheet.size() - 1
	hair_sprite.texture = cs.hair_spritesheet[hair_idx]

# Outfit
func _on_outfit_select_next() -> void:
	outfit_idx += 1
	if outfit_idx == cs.outfit_spritesheet.size():
		outfit_idx = 0
	outfit_sprite.texture = cs.outfit_spritesheet[outfit_idx]


func _on_outfit_select_prev() -> void:
	outfit_idx -= 1
	if outfit_idx < 0:
		outfit_idx = cs.outfit_spritesheet.size() - 1
	outfit_sprite.texture = cs.outfit_spritesheet[outfit_idx]

# Facial Hair
func _on_facial_hair_select_next() -> void:
	facial_hair_idx += 1
	if facial_hair_idx == cs.facial_hair_spritesheet.size():
		facial_hair_idx = 0
	facial_hair_sprite.texture = cs.facial_hair_spritesheet[facial_hair_idx]


func _on_facial_hair_select_prev() -> void:
	facial_hair_idx -= 1
	if facial_hair_idx < 0:
		facial_hair_idx = cs.facial_hair_spritesheet.size() - 1
	facial_hair_sprite.texture = cs.facial_hair_spritesheet[facial_hair_idx]

# Glasses
func _on_glasses_select_next() -> void:
	glasses_idx += 1
	if glasses_idx == cs.glasses_spritesheet.size():
		glasses_idx = 0
	glasses_sprite.texture = cs.glasses_spritesheet[glasses_idx]


func _on_glasses_select_prev() -> void:
	glasses_idx -= 1
	if glasses_idx < 0:
		glasses_idx = cs.glasses_spritesheet.size() - 1
	glasses_sprite.texture = cs.glasses_spritesheet[glasses_idx]

# Hats
func _on_hats_select_next() -> void:
	hats_idx += 1
	if hats_idx == cs.hats_spritesheet.size():
		hats_idx = 0
	hats_sprite.texture = cs.hats_spritesheet[hats_idx]


func _on_hats_select_prev() -> void:
	hats_idx -= 1
	if hats_idx < 0:
		hats_idx = cs.hats_spritesheet.size() - 1
	hats_sprite.texture = cs.hats_spritesheet[hats_idx]

# Random
func _on_randomize_button_pressed() -> void:
	hats_idx = rng.randi_range(0, cs.hats_spritesheet.size() - 1)
	hair_idx = rng.randi_range(0, cs.hair_spritesheet.size() - 1)
	eyes_idx = rng.randi_range(0, cs.eyes_spritesheet.size() - 1)
	glasses_idx = rng.randi_range(0, cs.glasses_spritesheet.size() - 1)
	facial_hair_idx = rng.randi_range(0, cs.facial_hair_spritesheet.size() - 1)
	body_idx = rng.randi_range(0, cs.body_spritesheet.size() - 1)
	outfit_idx = rng.randi_range(0, cs.outfit_spritesheet.size() - 1)
	
	hats_sprite.texture = cs.hats_spritesheet[hats_idx]
	hair_sprite.texture = cs.hair_spritesheet[hair_idx]
	eyes_sprite.texture = cs.eyes_spritesheet[eyes_idx]
	glasses_sprite.texture = cs.glasses_spritesheet[glasses_idx]
	facial_hair_sprite.texture = cs.facial_hair_spritesheet[facial_hair_idx]
	body_sprite.texture = cs.body_spritesheet[body_idx]
	outfit_sprite.texture = cs.outfit_spritesheet[outfit_idx]


func _on_save_button_pressed() -> void:
	PlayerInfo.player_customization = {
		'body': body_idx,
		'hair': hair_idx,
		'eyes': eyes_idx,
		'outfit': outfit_idx,
		'facial_hair': facial_hair_idx,
		'glasses': glasses_idx,
		'hats': hats_idx
	}
