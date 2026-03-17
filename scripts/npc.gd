extends Node3D

@onready var animation_player = $AnimationPlayer

func play_idle():
	animation_player.play("locomotion/Idle")

func play_walk():
	animation_player.play("locomotion/Walking")

func play_sit():
	animation_player.play("locomotion/Sit")

func play_lay():
	animation_player.play("locomotion/Laydown")
