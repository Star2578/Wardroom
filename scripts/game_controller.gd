extends Node


var is_started: bool = false
var is_paused: bool = false

var mouse_sensitivity: float = 0.01
var master_bus_index: int
var master_volume_db: float = linear_to_db(0.5)
var master_muted: bool = false
var brightness: float = 1.0
var return_scene_path: String = ""
var option_menu: Control = null
const OPTION_SCENE_PATH := "res://scenes/option.tscn"
const OPTION_RETURN_FALLBACK_SCENE := "res://scenes/main_menu.tscn"
var player: Player = null

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


func _ensure_option_menu() -> void:
	if option_menu and is_instance_valid(option_menu):
		return

	var option_scene := load(OPTION_SCENE_PATH) as PackedScene
	if option_scene == null:
		push_error("Unable to load option scene: %s" % OPTION_SCENE_PATH)
		return

	option_menu = option_scene.instantiate() as Control
	if option_menu == null:
		push_error("Option scene root must be a Control node")
		return

	option_menu.visible = false
	option_menu.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	option_menu.set_anchors_preset(Control.PRESET_FULL_RECT)
	option_menu.z_index = 100
	get_tree().root.add_child(option_menu)


func open_option_scene() -> void:
	_ensure_option_menu()

	if option_menu == null:
		return
	if option_menu.visible:
		return

	var current_scene := get_tree().current_scene
	if current_scene:
		var current_scene_path := current_scene.scene_file_path
		if current_scene_path != "" and current_scene_path != OPTION_SCENE_PATH:
			return_scene_path = current_scene_path

	get_tree().root.move_child(option_menu, -1)
	option_menu.visible = true
	is_paused = true
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func return_from_option() -> void:
	if option_menu and is_instance_valid(option_menu) and option_menu.visible:
		option_menu.visible = false
		is_paused = false
		get_tree().paused = false

		var current_scene := get_tree().current_scene
		if current_scene and current_scene.scene_file_path == "res://scenes/main_menu.tscn":
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

		return_scene_path = ""
		return

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
	if current_scene and current_scene.scene_file_path == OPTION_SCENE_PATH:
		return
	if option_menu and is_instance_valid(option_menu) and option_menu.visible:
		return

	var viewport := get_viewport()
	if viewport:
		viewport.set_input_as_handled()

	open_option_scene()

func pause_game():
	is_paused = !is_paused
	get_tree().paused = is_paused
