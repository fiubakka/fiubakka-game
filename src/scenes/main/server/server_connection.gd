extends Node

const Connection = preload("res://src/objects/server/connection.gd")

var _consumer: Node
var _producer: Node

var _conn: Connection


func _ready() -> void:
	_conn = Connection.new()
	if _conn.start().is_err():
		print("Failed to establish connection to server")
		return

	_consumer = get_node("ServerConsumer")
	_producer = get_node("ServerProducer")

	_consumer.start(_conn.consumer)
	_producer.start(_conn.producer)
