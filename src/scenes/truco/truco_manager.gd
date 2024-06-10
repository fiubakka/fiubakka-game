extends Node2D

signal play_ack(play_id: int)
signal play_card(play_id: int, card_id: int)
signal shout_played(shout_id: int)
signal player_disconnect
signal turn_over
signal game_over
signal opponent_abandoned

@export var card_scene: PackedScene

var hand: Hand = null
var board: Board = null
var selected_card: Card = null
var current_play_id := -1
var opponent_name: String
var opponent_controller: OpponentController = null
var opponent_hand: OpponentCards = null
var is_game_over := false
var is_match_over := false
var _last_play: TrucoLastPlayDto = null
var _can_play_cards := false
@onready var options: Options = $Options
@onready var game_over_timer: Timer = $GameOverTimer


func _ready() -> void:
	$Disconnect.text = tr("OPTION_QUIT")
	hand = $Hand
	board = $Board
	opponent_controller = $OpponentController
	opponent_hand = $OpponentHand

	$PlayerName.text = Utils.center_text(PlayerInfo.player_name)

	var consumer := get_node("/root/Main/ServerConnection/ServerConsumer")
	consumer.truco_play_card.connect(self._on_truco_play_card)
	consumer.truco_shout_played.connect(self._on_consumer_truco_shout_played)
	consumer.truco_play_update.connect(self._on_truco_play_update)
	consumer.allow_truco_play.connect(self._on_allow_truco_play)
	consumer.truco_opponent_disconnected.connect(self._on_opponent_disconnected)

	var producer := get_node("/root/Main/ServerConnection/ServerProducer")
	var producer_truco_ack_handler: Callable = producer._on_truco_manager_ack
	if !play_ack.is_connected(producer_truco_ack_handler):
		play_ack.connect(producer_truco_ack_handler)

	var producer_truco_play_handler: Callable = producer._on_truco_manager_play_card
	if !play_card.is_connected(producer_truco_play_handler):
		play_card.connect(producer_truco_play_handler)

	var producer_truco_shout_handler: Callable = producer._on_truco_manager_shout_played
	if !play_card.is_connected(producer_truco_shout_handler):
		shout_played.connect(producer._on_truco_manager_shout_played)

	var producer_truco_disconnect_handler: Callable = producer._on_truco_manager_disconnect
	if !player_disconnect.is_connected(producer_truco_disconnect_handler):
		player_disconnect.connect(producer_truco_disconnect_handler)

	var musicPlayer := get_node("/root/Main/MusicPlayer")
	var music_player_truco_disconnect_handler: Callable = musicPlayer._on_truco_manager_disconnect
	if !player_disconnect.is_connected(music_player_truco_disconnect_handler):
		player_disconnect.connect(music_player_truco_disconnect_handler)

	$GameOver.exit_button_pressed.connect(_on_disconnect_pressed)

	$PlayerIcon.visible = false
	$OpponentIcon.visible = true


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


func update_shouts(available_shouts: Array) -> void:
	options.set_available_shouts(available_shouts)


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
	options.disable_buttons(true)
	play_card.emit(current_play_id, card.id)
	turn_over.emit()
	_last_play = TrucoLastPlayDto.new(TrucoLastPlayDto.TYPES.CARD, card.id, -1)
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


func update_opponent_name(first_name: String, second_name: String) -> void:
	opponent_name = second_name if PlayerInfo.player_name == first_name else first_name
	$OpponentName.text = Utils.center_text(opponent_name)


func update_points(first_points: int, first_name: String, second_points: int) -> void:
	if PlayerInfo.player_name == first_name:
		$Points.set_points(first_points)
		$OpponentPoints.set_points(second_points)
	else:
		$Points.set_points(second_points)
		$OpponentPoints.set_points(first_points)


func _on_truco_play_card(dto: TrucoPlayCardDto) -> void:
	if dto.play_id == current_play_id:
		_last_play = null
		check_over_states(
			dto.game_over, dto.match_over, dto.first_name, dto.first_points, dto.second_points
		)
		update_shouts(dto.available_shouts)
		update_points(dto.first_points, dto.first_name, dto.second_points)

	# Ignore plays that are previous to the current one
	# Ignore plays with the same id too, since those are my own
	if dto.play_id <= current_play_id:
		play_ack.emit(dto.play_id)
		return

	check_over_states(
		dto.game_over, dto.match_over, dto.first_name, dto.first_points, dto.second_points
	)

	current_play_id = dto.play_id
	_can_play_cards = dto.is_play_card_available

	update_shouts(dto.available_shouts)
	update_points(dto.first_points, dto.first_name, dto.second_points)
	play_enemy_card(dto.suit, dto.rank)
	options.disable_buttons(true)

	play_ack.emit(dto.play_id)


func _on_consumer_truco_shout_played(dto: TrucoPlayShoutDto) -> void:
	if dto.play_id == current_play_id:
		_last_play = null
		check_over_states(
			dto.game_over, dto.match_over, dto.first_name, dto.first_points, dto.second_points
		)
		update_shouts(dto.available_shouts)
		update_points(dto.first_points, dto.first_name, dto.second_points)
		_can_play_cards = dto.is_play_card_available

	if dto.play_id <= current_play_id:
		play_ack.emit(dto.play_id)
		return

	check_over_states(
		dto.game_over, dto.match_over, dto.first_name, dto.first_points, dto.second_points
	)

	current_play_id = dto.play_id
	_can_play_cards = dto.is_play_card_available
	update_shouts(dto.available_shouts)
	update_points(dto.first_points, dto.first_name, dto.second_points)
	$DialogueBubbleController.show_shout(dto.shout)
	play_ack.emit(dto.play_id)


func _on_truco_play_update(dto: TrucoPlayUpdateDto) -> void:
	if dto.play_id == current_play_id:
		_last_play = null

	# Ignore plays that are previous or the same as the current one
	if dto.play_id <= current_play_id:
		play_ack.emit(dto.play_id)
		return

	current_play_id = dto.play_id
	_can_play_cards = dto.is_play_card_available
	if current_play_id == 0:
		update_opponent_name(dto.first_name, dto.second_name)
		clean()
		create_hand(dto.player_cards)
		update_shouts(dto.available_shouts)
		play_ack.emit(dto.play_id)
		return

	update_points(dto.first_points, dto.first_name, dto.second_points)

	# Clear board and update hand when going from game_over to new game
	if is_game_over and !dto.game_over:
		is_game_over = dto.game_over
		game_over_timer.timeout.connect(
			Callable(self, "_on_game_over_timer_timeout").bind(
				dto.play_id, dto.player_cards, dto.is_play_card_available, dto.available_shouts
			)
		)
		game_over_timer.start()
		return

	update_shouts(dto.available_shouts)
	play_ack.emit(dto.play_id)


func _on_game_over_timer_timeout(
	play_id: int, cards: Array[Card], is_play_card_available: bool, available_shouts: Array
) -> void:
	$RoundOver.visible = false
	clean()
	create_hand(cards)
	update_shouts(available_shouts)
	play_ack.emit(play_id)
	game_over.emit()
	game_over_timer.disconnect("timeout", self._on_game_over_timer_timeout)


func _on_allow_truco_play(play_id: int) -> void:
	# Ignore plays that are previous or the same as the current one
	# If it happens, send the last TrucoPlay for consistency with server
	if play_id <= current_play_id and _last_play:
		match _last_play.type:
			TrucoLastPlayDto.TYPES.CARD:
				play_card.emit(current_play_id, _last_play.card_id)
			TrucoLastPlayDto.TYPES.SHOUT:
				shout_played.emit(current_play_id, _last_play.shout_id)
		return

	current_play_id = play_id
	$PlayerIcon.visible = true
	$OpponentIcon.visible = false
	if _can_play_cards:
		board.enable_current_play_zone()

	if game_over_timer and !game_over_timer.is_stopped():
		await game_over_timer.timeout
	options.disable_buttons(false)


func _on_options_shout_played(shout_id: int) -> void:
	$PlayerIcon.visible = false
	$OpponentIcon.visible = true
	shout_played.emit(current_play_id, shout_id)
	_last_play = TrucoLastPlayDto.new(TrucoLastPlayDto.TYPES.SHOUT, -1, shout_id)
	options.disable_buttons(true)

	# Disable playing cards when I make a shout
	board.disable_current_play_zone()


func _on_disconnect_pressed() -> void:
	player_disconnect.emit()
	SceneManager.load_previous_scene()
	PlayerInfo.is_playing_truco = false


func _on_opponent_disconnected(disconnected_user_name: String) -> void:
	if opponent_name == disconnected_user_name:
		opponent_abandoned.emit()


func check_over_states(
	new_game_over: bool,
	new_match_over: bool,
	first_name: String,
	first_points: int,
	second_points: int
) -> void:
	# Always save game/match over flags
	is_game_over = new_game_over
	is_match_over = new_match_over

	var i_am_first := PlayerInfo.player_name == first_name
	var my_points := first_points if i_am_first else second_points
	var opponent_points := second_points if i_am_first else first_points

	if is_match_over:
		options.disable_buttons(true)
		$GameOver.set_match_result(my_points, opponent_points)
		return

	if is_game_over:
		game_over.emit()
		$RoundOver.visible = true
