extends Node3D

var can_use: bool = true

func use() -> void:
	if can_use:
		print("Using fireaxe!")
		can_use = false
