extends Node2D

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
#var next_turn_number := 0
var deck: Deck = null
var opponent_controller: OpponentController = null


func _ready() -> void:
	hand = $Hand
	board = $Board
	deck = preload("res://src/scenes/truco/deck/deck.gd").new()
	opponent_controller = $OpponentController

func start_round() -> void:
	clean()
	for i: int in range(0, 3):
		var card := card_scene.instantiate()
		card.get_selected.connect(self._on_card_get_selected)
		card.get_unselected.connect(self._on_card_get_unselected)
		card.texture = deck.deck_file
		card.region_rect = deck.deal(i, i)
		hand.add_cards(card)
	board.next_turn()
	opponent_controller.next_turn()


func next_turn() -> void:
	board.next_turn()
	opponent_controller.next_turn()


func clean() -> void:
	hand.clean()
	board.clean()
	opponent_controller.clean()

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


func _on_board_player_card_played(card: Card) -> void:
	card.played = true
	print("Carta jugada!")



# TODO: REMOVE
func _on_button_2_pressed() -> void:
	next_turn()


# TODO: REMOVE
func _on_button_3_pressed() -> void:
	start_round()


# TODO: REMOVE
func _on_button_4_pressed() -> void:
	$DialogueBubbleController.show_dialogue("Truco!")


func _on_button_5_pressed() -> void:
	#opponent_controller.set_hand(0, 0)
	var drop_zones := get_tree().get_nodes_in_group("opponent_table")
	for drop_zone: DropZone in get_tree().get_nodes_in_group("opponent_table"):
		if !drop_zone.has_card:
			opponent_controller.play_card(drop_zone)
			break
