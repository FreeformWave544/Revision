extends Control

@onready var list := $VBoxContainer
var discovery: Node

func _ready():
	if OS.has_feature("web"):
		print("Web build: LAN discovery disabled")
		return

	discovery = preload("res://LAN/LanDiscovery.gd").new()
	add_child(discovery)
	discovery.host_found.connect(_on_host_found)

func _on_host_found(info: Dictionary):
	var button := Button.new()
	button.text = "%s (%s)" % [info.name, info.ip]
	button.pressed.connect(func():
		join_host(info.ip, info.port)
	)
	list.add_child(button)

func join_host(ip: String, port := 8910):
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, port)
	multiplayer.multiplayer_peer = peer
	print("Connecting to ", ip)
