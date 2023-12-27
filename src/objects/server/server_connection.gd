extends Object

const Consumer = preload("res://src/objects/server/consumer.gd")
const Producer = preload("res://src/objects/server/producer.gd")

const PBServerMetadata = preload("res://src/protocol/compiled/server/metadata.gd")
const PBGameEntityState = preload("res://src/protocol/compiled/server/state/game_entity_state.gd")

const ServerMessageFactory = preload("res://src/objects/server/server_message_factory.gd")

const HOST = "127.0.0.1"
const PORT = 2020

var conn: StreamPeerTCP
var consumer: Consumer
var producer: Producer

func _init():
    conn = StreamPeerTCP.new()
    consumer = Consumer.new()
    producer = Producer.new()

func start() -> int:
    var r := conn.connect_to_host(HOST, PORT)
    if r != OK:
        printerr("Error connecting to server at " + HOST + ":" + str(PORT))
        return r
    r = conn.poll()
    if r != OK:
        printerr("Error polling server connection at " + HOST + ":" + str(PORT))
        return r
    consumer.start(conn)
    return OK

func stop():
    consumer.stop()
    conn.disconnect_from_host()
