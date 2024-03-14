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
	#for i: int in range(0, 3):
		#var card := card_scene.instantiate()
		#card.set_current_rest_point(drop_zones[i])
		#cards.append(card)
		#add_child(card)
