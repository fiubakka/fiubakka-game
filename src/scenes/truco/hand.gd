extends Control

class_name Hand

@export var card_scene: PackedScene

var cards := []
var drop_zones := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_zones.append($HBoxContainer/CenterContainer/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer2/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer3/Control/DropZone)


func add_cards(card: Card) -> void:
	card.set_current_rest_point(drop_zones[len(cards) % len(drop_zones)])
	cards.append(card)
	add_child(card)
	print(get_child_count())

