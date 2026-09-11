extends Node3D

@export var camera: Camera3D
@export var equipped_viewmodels: Node3D
@export var equipped: Equipment:
	set(new_equip):
		_remove_all_equipped_viewmodels()
		var new_equipped_scene: Node3D = new_equip.equipped_scene.instantiate()
		add_child(new_equipped_scene)


func _remove_all_equipped_viewmodels() -> void:
	for equipped_viewmodel: Node3D in equipped_viewmodels.get_children():
		equipped_viewmodels.remove_child(equipped_viewmodel)
		equipped_viewmodel.queue_free()
