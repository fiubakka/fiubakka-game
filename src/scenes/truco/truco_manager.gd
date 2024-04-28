extends Node2D

signal play_ack(play_id: int)
signal play_card(play_id: int)

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
var current_play_id := -1
var deck: Deck = null
var opponent_controller: OpponentController = null
var opponent_hand: OpponentCards = null


func _ready() -> void:
	hand = $Hand
	board = $Board
	opponent_controller = $OpponentController
	opponent_hand = $OpponentHand
	deck = preload("res://src/scenes/truco/deck/deck.gd").new()

	var consumer := get_node("/root/Main/ServerConnection/ServerConsumer")
	#consumer.truco_play_card.connect(self._on_truco_play_card)
	#consumer.truco_play_shout.connect(self._on_truco_play_shout)
	consumer.truco_play_update.connect(self._on_truco_play_update)
	consumer.allow_truco_play.connect(self._on_allow_truco_play)
		
	var producer := get_node("/root/Main/ServerConnection/ServerProducer")
	var producer_truco_ack_handler: Callable = (producer._on_truco_manager_ack)
	if !play_ack.is_connected(producer_truco_ack_handler):
		play_ack.connect(producer_truco_ack_handler)
		
	var producer_truco_play_handler: Callable = (producer._on_truco_manager_play)
	if !play_card.is_connected(producer_truco_play_handler):
		play_card.connect(producer_truco_play_handler)

func start_round(cards: Array[Card]) -> void:
	clean()
	for card in cards:
		var new_card := card_scene.instantiate()
		new_card.get_selected.connect(self._on_card_get_selected)
		new_card.get_unselected.connect(self._on_card_get_unselected)
		new_card.texture = card.texture
		new_card.region_rect = card.region_rect
		hand.add_cards(new_card)
	next_turn()


func next_turn() -> void:
	board.next_turn()
	opponent_controller.next_turn()


func clean() -> void:
	hand.clean()
	board.clean()
	opponent_controller.clean()
	opponent_hand.clean()

func _on_card_get_selected(card: Card) -> void:
	print("on card get selected")
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
	print("on card get unselected")
	selected_card.selected = false
	selected_card = null


func _on_board_player_card_played(card: Card) -> void:
	card.played = true
	
	print("Carta jugada!")


func _on_opponent_controller_remove_card_from_hand() -> void:
	opponent_hand.play_card()


# TODO: REMOVE
func _on_button_2_pressed() -> void:
	next_turn()


# TODO: REMOVE
func _on_button_3_pressed() -> void:
	start_round([])


# TODO: REMOVE
func _on_button_4_pressed() -> void:
	$DialogueBubbleController.show_dialogue("Truco!")


# TODO: REMOVE
func _on_button_5_pressed() -> void:
	var drop_zones := get_tree().get_nodes_in_group("opponent_table")
	for drop_zone: DropZone in get_tree().get_nodes_in_group("opponent_table"):
		if !drop_zone.has_card:
			opponent_controller.play_card(drop_zone)
			break

# TODO: REMOVE
func _on_button_6_pressed() -> void:
	$Board.player_wins(true)
	

# TODO: REMOVE
func _on_button_7_pressed() -> void:
	$Board.player_wins(false)

	
func _on_truco_play_update(play_id: int, cards: Array[Card]) -> void:
	# Ignore plays that are previous or the same as the current one
	if (play_id <= current_play_id):
		return
	current_play_id = play_id
	start_round(cards)
	play_ack.emit(play_id)
	
func _on_allow_truco_play(play_id: int) -> void:
	# Ignore plays that are previous or the same as the current one
	# Should never happen here, but we check just in case
	if (play_id <= current_play_id):
		return
	current_play_id = play_id
	
	# TODO: add logic to enable cards drag and drop
