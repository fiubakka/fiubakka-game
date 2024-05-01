extends Node2D

signal play_ack(play_id: int)
signal play_card(play_id: int, card_id: int)

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
var current_play_id := -1
var opponent_controller: OpponentController = null
var opponent_hand: OpponentCards = null


func _ready() -> void:
	hand = $Hand
	board = $Board
	opponent_controller = $OpponentController
	opponent_hand = $OpponentHand

	var consumer := get_node("/root/Main/ServerConnection/ServerConsumer")
	consumer.truco_play_card.connect(self._on_truco_play_card)
	#consumer.truco_play_shout.connect(self._on_truco_play_shout)
	consumer.truco_play_update.connect(self._on_truco_play_update)
	consumer.allow_truco_play.connect(self._on_allow_truco_play)
		
	var producer := get_node("/root/Main/ServerConnection/ServerProducer")
	var producer_truco_ack_handler: Callable = (producer._on_truco_manager_ack)
	if !play_ack.is_connected(producer_truco_ack_handler):
		play_ack.connect(producer_truco_ack_handler)
		
	var producer_truco_play_handler: Callable = (producer._on_truco_manager_play_card)
	if !play_card.is_connected(producer_truco_play_handler):
		play_card.connect(producer_truco_play_handler)


func create_hand(cards: Array[Card]) -> void:
	for card in cards:
		var new_card := card_scene.instantiate()
		new_card.get_selected.connect(self._on_card_get_selected)
		new_card.get_unselected.connect(self._on_card_get_unselected)
		new_card.id = card.id
		new_card.texture = card.texture
		new_card.region_rect = card.region_rect
		hand.add_cards(new_card)
		
	board.create_dropzones()
	opponent_controller.next_turn()
		
	
func update_hand(cards: Array[Card]) -> void:
	for card in cards:
		hand.update_card_id(card)


func clean() -> void:
	hand.clean() 
	board.clean()
	opponent_controller.clean()
	opponent_hand.clean()


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
	play_card.emit(current_play_id, card.id)
	$YourTurn.visible = false


func _on_opponent_controller_remove_card_from_hand() -> void:
	opponent_hand.play_card()


func play_enemy_card(suit: int, rank: int) -> void:
	opponent_controller.set_hand(rank, suit)
	var drop_zones := get_tree().get_nodes_in_group("opponent_table")
	for drop_zone: DropZone in drop_zones:
		if !drop_zone.has_card:
			opponent_controller.play_card(drop_zone)
			break


func _on_truco_play_card(play_id: int, suit: int, rank: int, cards: Array[Card]) -> void:
	# Ignore plays that are previous to the current one
	# Ignore plays with the same id too, since those are my own
	if(play_id <= current_play_id):
		play_ack.emit(play_id)
		return
	current_play_id = play_id
	play_enemy_card(suit, rank)
	update_hand(cards)
	
	play_ack.emit(play_id)
	


func _on_truco_play_update(play_id: int, cards: Array[Card], game_over: bool, match_over: bool) -> void:
	# Ignore plays that are previous or the same as the current one
	if (play_id <= current_play_id):
		play_ack.emit(play_id)
		return
	current_play_id = play_id
	
	if game_over:
		var timer := Timer.new()
		timer.timeout.connect(Callable(self, "_on_timer_timeout").bind(play_id, cards, timer))
		timer.one_shot = true
		timer.set_wait_time(3.0)
		add_child(timer)
		timer.start()
		return
	if current_play_id == 0:
		clean()
		create_hand(cards)
		play_ack.emit(play_id)
		return
	
	update_hand(cards)
	play_ack.emit(play_id)
	
func _on_timer_timeout(play_id: int, cards: Array[Card], timer: Timer) -> void:
	clean()
	create_hand(cards)
	play_ack.emit(play_id)
	timer.queue_free()
	return

func _on_allow_truco_play(play_id: int) -> void:
	# Ignore plays that are previous or the same as the current one
	# Should never happen here, but we check just in case
	if (play_id <= current_play_id):
		return
	current_play_id = play_id
	$YourTurn.visible = true
	board.enable_play_zone()
