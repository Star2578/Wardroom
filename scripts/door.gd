extends Node3D

class_name Door

@export var destination: Node3D

func interact():
	print("interact door")
	GameController.player.position = destination.global_position
