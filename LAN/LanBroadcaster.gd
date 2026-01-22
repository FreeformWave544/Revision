extends Node

const DISCOVERY_PORT := 8911
const BROADCAST_INTERVAL := 1.0

var udp := PacketPeerUDP.new()
var timer := 0.0

@export var server_port := 8910
@export var server_name := "Host"

func _ready():
	udp.set_broadcast_enabled(true)
	udp.listen(0)

func _process(delta):
	timer += delta
	if timer >= BROADCAST_INTERVAL:
		timer = 0.0
		_broadcast()

func _broadcast():
	var data := {
		"name": server_name,
		"port": server_port
	}
	var packet := JSON.stringify(data).to_utf8_buffer()

	udp.set_dest_address("255.255.255.255", DISCOVERY_PORT)
	udp.put_packet(packet)
