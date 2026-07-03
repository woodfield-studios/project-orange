extends Node3D

@export var player_scene: PackedScene


func _ready() -> void:
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(del_player)

	for peer_id in multiplayer.get_peers():
		add_player(peer_id)

	if not OS.has_feature("dedicated_server"):
		add_player(1)


func add_player(player_id: int):
	var player = player_scene.instantiate()

	player.player_id = player_id
	player.position = Vector3(0, 3, 0)
	player.name = str(player_id)

	$Players.add_child(player, true)


func del_player(player_id: int):
	if not $Players.has_node(str(player_id)):
		return

	$Players.get_node(str(player_id)).queue_free()


func _exit_tree() -> void:
	if not multiplayer.is_server():
		return

	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_connected.disconnect(del_player)
