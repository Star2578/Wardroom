extends Node


var is_started: bool = false

var mouse_sensitivity: float = 0.01

var player: Player = null

func _ready() -> void:
	print("GameManager Initiated")
