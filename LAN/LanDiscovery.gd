extends Node

signal host_found(info: Dictionary)

const DISCOVERY_PORT := 8911

var udp := PacketPeerUDP.new()
var known_hosts := {}

func _ready():
	udp.set_broadcast_enabled(true)

	var err := udp.bind(DISCOVERY_PORT)
	if err != OK:
		push_error("Discovery bind failed: " + error_string(err))
		return

	print("LAN discovery listening")

func _process(_delta):
	while udp.get_available_packet_count() > 0:
		var packet := udp.get_packet()
		var ip := udp.get_packet_ip()

		var json := JSON.new()
		if json.parse(packet.get_string_from_utf8()) != OK:
			continue

		var data = json.get_data()
		if typeof(data) != TYPE_DICTIONARY:
			continue

		var key := ip + ":" + str(data.port)
		if known_hosts.has(key):
			continue

		data.ip = ip
		known_hosts[key] = data
		emit_signal("host_found", data)
