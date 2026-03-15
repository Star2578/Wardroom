extends Node


var is_started: bool = false
var is_paused: bool = false

var mouse_sensitivity: float = 0.01

var player: Player = null

func _ready() -> void:
	print("GameManager Initiated")

func pause_game():
	is_paused = !is_paused
	get_tree().paused = is_paused