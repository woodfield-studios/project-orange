extends Node3D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D


func play_audio() -> void:
	audio.play()


func play_animation() -> void:
	animation_player.play("use")


func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	animation_player.play("RESET")
