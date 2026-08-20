extends Node

@export var multiplayer_ui: Control
@export var host_address_input: LineEdit
@export var initial_scene: PackedScene

const PORT: int = 8080


func _on_host_mode_pressed() -> void:
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_client_pressed() -> void:
	var host_address: String = host_address_input.text
	var ip: String = "localhost" if host_address.is_empty() else host_address
	var peer: ENetMultiplayerPeer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game() -> void:
	multiplayer_ui.hide()

	if multiplayer.is_server():
		change_level.call_deferred(initial_scene)


func change_level(scene: PackedScene) -> void:
	var level: Node3D = get_node("Level")
	for c: Node3D in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())
