extends Node2D

@export var card_scene: PackedScene

var hand: Hand = null;
var selected_card: Card = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hand = $Panel/Hand
	for i: int in range(0, 3):
		var card := card_scene.instantiate()
		card.get_selected.connect(self._on_card_get_selected)
		card.get_unselected.connect(self._on_card_get_unselected)
		card.number = i
		hand.add_cards(card)
		add_child(card)


func _on_card_get_selected(card: Card) -> void:
	if !selected_card:
		selected_card = card
		card.selected = true
	else:
		var cards := get_tree().get_nodes_in_group("cards")
		var selected_card_index := cards.find(selected_card, 0)
		var new_selected_card_index := cards.find(card, 0)
		if new_selected_card_index > selected_card_index:
			selected_card.selected = false
			selected_card = card
			selected_card.selected = true


func _on_card_get_unselected() -> void:
	selected_card.selected = false
	selected_card = null


