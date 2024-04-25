extends Node2D

signal play_ack(play_id: int)

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
var current_play_id := -1
var deck: Deck = null


func _ready() -> void:
	hand = $Hand
	board = $Board
	deck = preload("res://src/scenes/truco/deck/deck.gd").new()
	
	get_node("/root/Main/ServerConnection/ServerConsumer").truco_play.connect(
		self._on_truco_play
	)
	var producer_truco_ack_handler: Callable = (
		get_node("/root/Main/ServerConnection/ServerProducer")._on_truco_manager_ack
	)
	if !play_ack.is_connected(producer_truco_ack_handler):
		print("connected truco ack signal")
		play_ack.connect(producer_truco_ack_handler)


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


func next_turn() -> void:
	board.next_turn()


func clean() -> void:
	hand.clean()
	board.clean()


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
	
func _on_truco_play(play_id: int) -> void:
	# Ignore plays that are previous or the same as the current one
	if (play_id <= current_play_id):
		return
	current_play_id = play_id
	
	play_ack.emit(play_id)
	print("ack signal sent")
	
