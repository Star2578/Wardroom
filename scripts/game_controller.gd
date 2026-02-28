extends Node


var is_started: bool = false

var mouse_sensitivity: float = 0.1
var master_bus_index: int
var master_volume_db: float = linear_to_db(0.5)
var master_muted: bool = false
var brightness: float = 1.0

func _ready() -> void:
	print("GameManager Initiated")
	master_bus_index = AudioServer.get_bus_index("Master")
	master_muted = AudioServer.is_bus_mute(master_bus_index)
	apply_audio_settings()
	apply_brightness_settings()


func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(master_bus_index, master_volume_db)
	AudioServer.set_bus_mute(master_bus_index, master_muted)

func apply_brightness_settings() -> void:
	for node in get_tree().get_nodes_in_group("world_environments"):
		if node is WorldEnvironment and node.environment != null:
			node.environment.adjustment_enabled = true
			node.environment.adjustment_brightness = brightness
