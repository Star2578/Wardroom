extends VBoxContainer

@onready var input_button_scene = preload("res://scenes/input_mapping.tscn")
@onready var action_list = $PanelContainer/MarginContainer/ActionList

var is_remapping = false
var action_to_remap = null
var remapping_button = null

var input_actions = {
	"move_forward": "Move forward",
	"move_backward": "Move backward",
	"move_left": "Move left",
	"move_right": "Move right",
	"interact": "Interact",
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
		
		action_label.text = input_actions[action]
		
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
	if is_remapping:
		if (
			event is InputEventKey ||
			(event is InputEventMouseButton && event.pressed)
		):
			if event is InputEventMouseButton && event.double_click:
				event.double_click = false
			InputMap.action_erase_event(action_to_remap, event)
			InputMap.action_add_event(action_to_remap, event)
			_update_action_list(remapping_button, event)
			
			is_remapping = false
			action_to_remap = null
			remapping_button = null
			
			accept_event()
			
func _update_action_list(button, event):
	button.find_child("LabelInput").text = event.as_text().trim_suffix(" - Physical")


func _on_reset_btn_pressed() -> void:
	_create_action_list()
