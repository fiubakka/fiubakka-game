extends Control

class_name Hand

@export var card_scene: PackedScene

var hand := []
var drop_zones := []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	drop_zones.append($HBoxContainer/CenterContainer/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer2/Control/DropZone)
	drop_zones.append($HBoxContainer/CenterContainer3/Control/DropZone)


func add_cards(card: Card) -> void:
	card.set_current_rest_point(drop_zones[len(hand) % len(drop_zones)])
	hand.append(card)
	add_child(card)


func clean() -> void:
	#for card: Card in hand:
		#remove_child(card)
		#card.queue_free()
	#hand = []
	pass
	
	for drop_zone: DropZone in drop_zones:
		drop_zone.deselect()
	

