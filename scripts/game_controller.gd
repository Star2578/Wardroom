extends Node


@onready var options_menu: Option = $"CanvasLayer/Option"
@onready var option: OptionModified = $"CanvasLayer/OptionModified"
@onready var text_writer: TextWriter = $"TextWriter"

var is_started: bool = false
var is_paused: bool = false
var is_using_phone: bool = false

var can_look_around: bool = true

var got_phone: bool = false
var got_plunger: bool = false
var got_scissors: bool = false

var mouse_sensitivity: float = 0.01
var invert_camera_x_axis: bool = false
var invert_camera_y_axis: bool = false
var master_bus_index: int
var master_volume_db: float = linear_to_db(0.5)
var master_muted: bool = false
var brightness: float = 1.0

var main_menu: Control = null
var player: Player = null
var cutscene_player: CutscenePlayer = null
var dialogue_ui: DialogueUI = null
var interactable_ui: InteractableUI = null
var inventory_ui: InventoryUI = null
var inspect_item_ui: InspectItemUI = null

func _ready():
	print("GameManager Initiated")
	master_bus_index = AudioServer.get_bus_index("Master")
	master_muted = AudioServer.is_bus_mute(master_bus_index)
	_connect_scene_change_hooks()
	apply_audio_settings()
	apply_brightness_settings()


func apply_audio_settings():
	AudioServer.set_bus_volume_db(master_bus_index, master_volume_db)
	AudioServer.set_bus_mute(master_bus_index, master_muted)

func apply_brightness_settings():
	for node in get_tree().get_nodes_in_group("world_environments"):
		if node is WorldEnvironment and node.environment != null:
			node.environment.adjustment_enabled = true
			node.environment.adjustment_brightness = brightness
			print("Applied brightness: ", brightness, " to ", node.name)


func _connect_scene_change_hooks() -> void:
	var tree := get_tree()
	var scene_changed_callable := Callable(self, "_on_current_scene_changed")
	if tree.has_signal("current_scene_changed"):
		if not tree.is_connected("current_scene_changed", scene_changed_callable):
			tree.connect("current_scene_changed", scene_changed_callable)
		return

	var node_added_callable := Callable(self, "_on_tree_node_added")
	if not tree.is_connected("node_added", node_added_callable):
		tree.connect("node_added", node_added_callable)


func _on_current_scene_changed(_new_scene: Node) -> void:
	# Run deferred so the new scene has finished entering the tree.
	call_deferred("apply_brightness_settings")


func _on_tree_node_added(node: Node) -> void:
	if node == get_tree().current_scene:
		# Fallback for engine versions without current_scene_changed.
		call_deferred("apply_brightness_settings")


func toggle_options_menu():
	if !is_started:
		return
			
	if option.visible:
		option.visible = false
		options_menu.visible = true
		return
		
	options_menu.visible = not options_menu.visible
	
	if options_menu.visible:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		if player:
			player.immobile = true
		get_tree().paused = true
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		if player:
			player.immobile = false
		get_tree().paused = false

func some_ui_is_open() -> bool:
	if dialogue_ui != null and interactable_ui != null and inventory_ui != null and inspect_item_ui != null:
		return dialogue_ui.visible or interactable_ui.visible or inventory_ui.visible or inspect_item_ui.visible
	return false

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("inventory") and interactable_ui:
		GameController.toggle_pause_game()
		inventory_ui.toggle()
	
	if event.is_action_pressed("ui_cancel"):
		var viewport := get_viewport()
		if viewport:
			viewport.set_input_as_handled()

		toggle_options_menu()

func toggle_pause_game():
	is_paused = !is_paused
	get_tree().paused = is_paused
