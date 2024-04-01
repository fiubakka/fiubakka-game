extends Control

class_name Hand

@export var card_scene: PackedScene

var hand := []
var drop_zones := []


func _ready() -> void:
	drop_zones.append($HBoxContainer/Control/DropZone)
	drop_zones.append($HBoxContainer/Control2/DropZone)
	drop_zones.append($HBoxContainer/Control3/DropZone)


func add_cards(card: Card) -> void:
	card.set_current_rest_point(drop_zones[len(hand) % len(drop_zones)])
	hand.append(card)
	add_child(card)


func clean() -> void:
	for card: Card in hand:
		remove_child(card)
		card.queue_free()
	hand = []



