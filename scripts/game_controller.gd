extends Node


var is_started: bool = false

var mouse_sensitivity: float = 0.1
var master_volume_db: float = 0.0
var master_muted: bool = false
var brightness: float = 1.0

func _ready() -> void:
	print("GameManager Initiated")
	master_volume_db = AudioServer.get_bus_volume_db(0)
	master_muted = AudioServer.is_bus_mute(0)
	apply_audio_settings()
	apply_brightness_settings()


func apply_audio_settings() -> void:
	AudioServer.set_bus_volume_db(0, master_volume_db)
	AudioServer.set_bus_mute(0, master_muted)

func apply_brightness_settings() -> void:
	for node in get_tree().get_nodes_in_group("world_environments"):
		if node is WorldEnvironment and node.environment != null:
			node.environment.adjustment_enabled = true
			node.environment.adjustment_brightness = brightness
