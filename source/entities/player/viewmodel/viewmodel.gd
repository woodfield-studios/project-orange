extends Node3D

@export var camera: Camera3D
@export var hands: Node3D


func update_equipped(new_equipment: Equipment) -> void:
	for equipment_node: Node3D in hands.get_children():
		hands.remove_child(equipment_node)
		equipment_node.queue_free()

	var new_equipment_node: Node3D = new_equipment.scene.instantiate()
	hands.add_child(new_equipment_node)

func use() -> void:
	pass
