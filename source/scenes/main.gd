extends Node

@export var multiplayer_ui: Control
@export var initial_scene: PackedScene

const PORT = 8080


func _on_host_mode_pressed() -> void:
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


func _on_connect_client_pressed() -> void:
	var ip = "127.0.0.1"
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	start_game()


func start_game():
	multiplayer_ui.hide()

	if multiplayer.is_server():
		change_level.call_deferred(initial_scene)


func change_level(scene: PackedScene):
	var level = get_node("Level")
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	level.add_child(scene.instantiate())
