extends Node2D

signal play_ack(play_id: int)
signal play_card(play_id: int, card_id: int)
signal shout_played(shout_id: int)

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
var current_play_id := -1
var opponent_controller: OpponentController = null
var opponent_hand: OpponentCards = null
var is_game_over := false
var is_match_over := false
var _can_play_cards := false
@onready var options : Options = $Options


func _ready() -> void:
	hand = $Hand
	board = $Board
	opponent_controller = $OpponentController
	opponent_hand = $OpponentHand

	options.shout_played.connect(self._on_options_shout_played)
	
	$PlayerName.text = Utils.center_text(PlayerInfo.player_name)

	var consumer := get_node("/root/Main/ServerConnection/ServerConsumer")
	consumer.truco_play_card.connect(self._on_truco_play_card)
	#consumer.truco_play_shout.connect(self._on_truco_play_shout)
	consumer.truco_available_shouts.connect(self._on_consumer_truco_available_shouts)
	consumer.truco_play_update.connect(self._on_truco_play_update)
	consumer.allow_truco_play.connect(self._on_allow_truco_play)

	var producer := get_node("/root/Main/ServerConnection/ServerProducer")
	var producer_truco_ack_handler: Callable = producer._on_truco_manager_ack
	if !play_ack.is_connected(producer_truco_ack_handler):
		play_ack.connect(producer_truco_ack_handler)

	var producer_truco_play_handler: Callable = producer._on_truco_manager_play_card
	if !play_card.is_connected(producer_truco_play_handler):
		play_card.connect(producer_truco_play_handler)
	
	shout_played.connect(producer._on_truco_manager_shout_played)

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


func update_shouts(is_play_card_available: bool, available_shouts: Array) -> void:
	options.set_available_shouts(is_play_card_available, available_shouts)


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
	if not _can_play_cards:
		return
	card.played = true
	play_card.emit(current_play_id, card.id)
	$PlayerIcon.visible = false
	$OpponentIcon.visible = true


func _on_opponent_controller_remove_card_from_hand() -> void:
	opponent_hand.play_card()


func play_enemy_card(suit: int, rank: int) -> void:
	opponent_controller.set_hand(rank, suit)
	var drop_zones := get_tree().get_nodes_in_group("opponent_table")
	for drop_zone: DropZone in drop_zones:
		if !drop_zone.has_card:
			opponent_controller.play_card(drop_zone)
			break


func _on_consumer_truco_available_shouts(
	play_id: int, isPlayCardAvailable: bool, shouts: Array) -> void:
	if (play_id <= current_play_id):
		play_ack.emit(play_id)
		return
	$PlayerIcon.visible = true
	$OpponentIcon.visible = false
	current_play_id = play_id
	_can_play_cards = isPlayCardAvailable
	options.set_available_shouts(isPlayCardAvailable, shouts)
	play_ack.emit(play_id)


func update_opponent_name(first_name: String, second_name: String) -> void:
	var opponent_name := second_name if PlayerInfo.player_name == first_name else first_name
	$OpponentName.text = Utils.center_text(opponent_name)


func update_points(
	first_points: int, first_name: String, second_points: int, second_name: String
) -> void:
	if PlayerInfo.player_name == first_name:
		$Points.set_points(first_points)
		$OpponentPoints.set_points(second_points)
	else:
		$Points.set_points(second_points)
		$OpponentPoints.set_points(first_points)


func _on_truco_play_card(play_id: int, suit: int, rank: int,
	cards: Array[Card], game_over: bool, match_over: bool,
	first_points: int, first_name: String, second_points: int, second_name: String,
	is_play_card_available: bool,
	available_shouts: Array
) -> void:
	# Always save game/match over flags
	is_game_over = game_over
	is_match_over = match_over
	
	if is_game_over:
		$RoundOver.visible = true
	
	# Ignore plays that are previous to the current one
	# Ignore plays with the same id too, since those are my own
	if play_id <= current_play_id:
		play_ack.emit(play_id)
		return
	current_play_id = play_id
	_can_play_cards = is_play_card_available

	update_shouts(is_play_card_available, available_shouts)
	update_points(first_points, first_name, second_points, second_name)
	play_enemy_card(suit, rank)
	update_hand(cards)
	options.disable_buttons(true)

	play_ack.emit(play_id)


func _on_truco_play_update(play_id: int, cards: Array[Card],
	game_over: bool, match_over: bool,
	first_points: int, first_name: String, second_points: int, second_name: String,
	is_play_card_available: bool,
	available_shouts: Array
) -> void:
	# Ignore plays that are previous or the same as the current one
	if play_id <= current_play_id:
		play_ack.emit(play_id)
		return
	current_play_id = play_id
	_can_play_cards = is_play_card_available
	update_shouts(is_play_card_available, available_shouts)
	
	if current_play_id == 0:
		update_opponent_name(first_name, second_name)
		clean()
		create_hand(cards)
		options.disable_buttons(true)
		play_ack.emit(play_id)
		return

	update_points(first_points, first_name, second_points, second_name)

	# Clear board and update hand when going from game_over to new game
	if is_game_over and !game_over:
		is_game_over = game_over
		var timer := Timer.new()
		timer.timeout.connect(
			Callable(self, "_on_game_over_timer_timeout").bind(play_id, cards, timer)
		)
		timer.one_shot = true
		timer.set_wait_time(3.0)
		add_child(timer)
		timer.start()
		return

	update_hand(cards)
	play_ack.emit(play_id)


func _on_game_over_timer_timeout(play_id: int, cards: Array[Card], timer: Timer) -> void:
	$RoundOver.visible = false
	clean()
	create_hand(cards)
	play_ack.emit(play_id)
	timer.queue_free()
	return


func _on_allow_truco_play(play_id: int) -> void:
	# Ignore plays that are previous or the same as the current one
	# Should never happen here, but we check just in case
	if play_id <= current_play_id:
		return
	current_play_id = play_id
	$PlayerIcon.visible = true
	$OpponentIcon.visible = false
	if _can_play_cards:
		board.enable_play_zone()
	options.disable_buttons(false)


func _on_options_shout_played(shout_id: int) -> void:
	$PlayerIcon.visible = false
	$OpponentIcon.visible = true
	shout_played.emit(current_play_id, shout_id)
	options.disable_buttons(true)

	# Disable playing cards when I make a shout
	# TODO: handle properly by counting which turn are we in
	# and then disabling the play_zone of that turn
	# (to avoid disabling previously played zones)
	if shout_id == 0 or shout_id == 5:
		board.disable_play_zone()
