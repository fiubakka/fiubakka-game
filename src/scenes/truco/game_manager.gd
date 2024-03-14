extends Node2D

@export var card_scene: PackedScene

var hand: Hand = null;

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand = $Panel/Hand
	for i: int in range(0, 3):
		var card := card_scene.instantiate()
		card.number = i
		hand.add_cards(card)
		add_child(card)


