extends Node2D

class_name OpponentController

@export var card_scene: PackedScene

var deck: Deck = null
var drop_zone: DropZone = null
var card: Card = null
var opponent_hand: DropZone = null

signal remove_card_from_hand


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	deck = preload("res://src/scenes/truco/deck/deck.gd").new()
	opponent_hand = $OpponentHand


func set_hand(rank: int, suit: int) -> void:
	card = card_scene.instantiate()
	card.texture = deck.deck_file
	card.region_rect = deck.deal(rank, suit)
	card.set_current_rest_point(opponent_hand)
	opponent_hand.select(card)
	opponent_hand.add_child(card)


func play_card(_drop_zone: DropZone) -> void:
	drop_zone = _drop_zone
	drop_zone.select(card)
	card.set_current_rest_point(drop_zone)
	remove_card_from_hand.emit()


func next_turn() -> void:
	card = null
	drop_zone = null
	opponent_hand.deselect()
	set_hand(0, 0)


func clean() -> void:
	var childs := $OpponentHand.get_children()
	for child: Card in childs:
		child.queue_free()
	card = null
	drop_zone = null
