extends Node3D

@export var camera: Camera3D
@export var equipped_viewmodels: Node3D
@export var equipped: Equipment:
	set(new_equip):
		remove_all_equipped()
		var new_equipped_scene: Node3D = new_equip.equipped_scene.instantiate()
		new_equipped_scene.user_id = user_id
		equipped_viewmodels.add_child(new_equipped_scene)

var user_id: int = 1


func use_equipped() -> void:
	for equipped_viewmodel: Node3D in equipped_viewmodels.get_children():
		equipped_viewmodel.use()


func remove_all_equipped() -> void:
	for equipped_viewmodel: Node3D in equipped_viewmodels.get_children():
		equipped_viewmodels.remove_child(equipped_viewmodel)
		equipped_viewmodel.queue_free()
