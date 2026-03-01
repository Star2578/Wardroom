extends Node


var is_started: bool = false

var mouse_sensitivity: float = 0.1
var master_bus_index: int
var master_volume_db: float = linear_to_db(0.5)
var master_muted: bool = false
var brightness: float = 1.0
var return_scene_path: String = ""
const OPTION_RETURN_FALLBACK_SCENE := "res://scenes/main_menu.tscn"

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


func open_option_scene() -> void:
	var current_scene := get_tree().current_scene
	if current_scene:
		var current_scene_path := current_scene.scene_file_path
		if current_scene_path != "" and current_scene_path != "res://scenes/option.tscn":
			return_scene_path = current_scene_path

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/option.tscn")


func return_from_option() -> void:
	var target_scene_path := return_scene_path
	if target_scene_path == "":
		target_scene_path = OPTION_RETURN_FALLBACK_SCENE

	return_scene_path = ""
	get_tree().change_scene_to_file(target_scene_path)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_pressed("ui_cancel"):
		return

	var current_scene := get_tree().current_scene

	if current_scene and current_scene.scene_file_path == "res://scenes/main_menu.tscn":
		return
	if current_scene and current_scene.scene_file_path == "res://scenes/option.tscn":
		return

	open_option_scene()
	get_viewport().set_input_as_handled()
