extends Node3D

@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func play_audio() -> void:
	audio.play()


func play_animation() -> void:
	animation.play("shoot")
