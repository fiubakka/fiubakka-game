extends Node2D

@onready var body_sprite := $CharacterSprite/Body
@onready var hair_sprite := $CharacterSprite/Hair
@onready var eyes_sprite := $CharacterSprite/Eyes
@onready var outfit_sprite := $CharacterSprite/Outfit
@onready var facial_hair_sprite := $CharacterSprite/FacialHair
@onready var glasses_sprite := $CharacterSprite/Glasses
@onready var hats_sprite := $CharacterSprite/Hats

var cs := CompositeSprites
var pc := PlayerInfo.player_customization


func _ready() -> void:
	body_sprite.texture = cs.body_spritesheet[pc["body"]]
	hair_sprite.texture = cs.hair_spritesheet[pc["hair"]]
	eyes_sprite.texture = cs.eyes_spritesheet[pc["eyes"]]
	outfit_sprite.texture = cs.outfit_spritesheet[pc["outfit"]]
	facial_hair_sprite.texture = cs.facial_hair_spritesheet[pc["facial_hair"]]
	glasses_sprite.texture = cs.glasses_spritesheet[pc["glasses"]]
	hats_sprite.texture = cs.hats_spritesheet[pc["hats"]]
