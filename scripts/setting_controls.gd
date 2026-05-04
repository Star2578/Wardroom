extends VBoxContainer

@onready var input_button_scene = preload("res://scenes/input_mapping.tscn")
@onready var action_list = $PanelContainer/MarginContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_forward": {
		"name": "MOVE_FORWARD",
		"description": "DESC_MOVE_FORWARD"
	},
	"move_backward": {
		"name": "MOVE_BACKWARD",
		"description": "DESC_MOVE_BACKWARD"
	},
	"move_left": {
		"name": "MOVE_LEFT",
		"description": "DESC_MOVE_LEFT"
	},
	"move_right": {
		"name": "MOVE_RIGHT",
		"description": "DESC_MOVE_RIGHT"
	},
	"crouch": {
		"name": "CROUCH",
		"description": "DESC_CROUCH"
	},
	"interact": {
		"name": "INTERACT",
		"description": "DESC_INTERACT"
	},
	"inventory": {
		"name": "INVENTORY",
		"description": "DESC_INVENTORY"
	}
}

func _ready():
	_create_action_list()
	
func _create_action_list():
	InputMap.load_from_project_settings()
	
	var reset_panel = action_list.get_node("ResetPanel")
	
	for item in action_list.get_children():
		if item.name != "ResetPanel":
			item.queue_free()
			
	action_list.remove_child(reset_panel)
	
	for action in input_actions:
		var button = input_button_scene.instantiate()
		var action_label = button.find_child("LabelAction")
		var input_label = button.find_child("LabelInput")
		
		var data = input_actions[action]
		action_label.text = data["name"]
		
		
		var events = InputMap.action_get_events(action)
		if events.size() > 0:
			input_label.text = events[0].as_text().trim_suffix(" - Physical")
		else:
			input_label.text = ""
			
		action_list.add_child(button)
		button.find_child("Button").pressed.connect(_on_input_button_pressed.bind(button, action))
		
	action_list.add_child(reset_panel)
		
func _on_input_button_pressed(button, action):
	if !is_remapping:
		is_remapping = true
		action_to_remap = action
		remapping_button = button
		button.find_child("LabelInput").text = "Press key to bind..."
		
	
func _input(event):
	if not is_remapping:
		return

	# --- 1. Cancel with ESC ---
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			_cancel_remap()
			return

	# --- 2. Only accept valid inputs ---
	if not (
		event is InputEventKey or
		(event is InputEventMouseButton and event.pressed)
	):
		return

	# Prevent double click weirdness
	if event is InputEventMouseButton and event.double_click:
		event.double_click = false

	# --- 3. Check if key already used somewhere else ---
	for action in InputMap.get_actions():
		if action == action_to_remap:
			continue  # skip itself

		for e in InputMap.action_get_events(action):
			if e.as_text() == event.as_text():
				# ❌ Key already used → do NOTHING
				return

	# --- 4. Apply binding (clean replace) ---
	for e in InputMap.action_get_events(action_to_remap):
		InputMap.action_erase_event(action_to_remap, e)

	InputMap.action_add_event(action_to_remap, event)
	_update_action_list(remapping_button, event)

	# --- 5. Exit remap mode ---
	is_remapping = false
	action_to_remap = null
	remapping_button = null

	accept_event()
			
func _cancel_remap():
	# restore original text
	var events = InputMap.action_get_events(action_to_remap)
	if events.size() > 0:
		remapping_button.find_child("LabelInput").text = events[0].as_text().trim_suffix(" - Physical")
	else:
		remapping_button.find_child("LabelInput").text = ""

	is_remapping = false
	action_to_remap = null
	remapping_button = null
	
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" - Physical")


func _on_reset_btn_pressed() -> void:
	_create_action_list()
