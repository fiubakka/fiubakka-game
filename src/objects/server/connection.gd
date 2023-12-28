extends Object

const Consumer = preload("res://src/objects/server/consumer/consumer.gd")
const Producer = preload("res://src/objects/server/producer/producer.gd")

const HOST = "127.0.0.1"
const PORT = 2020

var _conn: StreamPeerTCP
var consumer: Consumer
var producer: Producer


func _init() -> void:
	_conn = StreamPeerTCP.new()


func start() -> Result:
	var r := _conn.connect_to_host(HOST, PORT)
	if r != OK:
		printerr("Error connecting to server at " + HOST + ":" + str(PORT))
		return Result.err(r)
	r = _conn.poll()
	if r != OK:
		printerr("Error polling server connection at " + HOST + ":" + str(PORT))
		return Result.err(r)
	consumer = Consumer.new(_conn)
	producer = Producer.new(_conn)

	return Result.ok(null)


func stop() -> void:
	_conn.disconnect_from_host()
