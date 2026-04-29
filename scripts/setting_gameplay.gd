extends VBoxContainer

@onready var language_label = $PanelContainer/MarginContainer/VBoxContainer/Language/HBoxContainer/HBoxContainer/PanelContainer/LanguageLabel

@onready var mc_sensitivity_number_label = $PanelContainer/MarginContainer/VBoxContainer/MouseCameraSensitivity/HBoxContainer/PanelContainer/MCSensitivityNumberLabel
@onready var mc_sensitivity_slider = $PanelContainer/MarginContainer/VBoxContainer/MouseCameraSensitivity/HBoxContainer/PanelContainer2/MCSensitivitySlider

@onready var invert_y_off_btn = $PanelContainer/MarginContainer/VBoxContainer/InvertYAxis/HBoxContainer/PanelContainer/MarginContainer/InvertYOffBtn
@onready var invert_y_on_btn = $PanelContainer/MarginContainer/VBoxContainer/InvertYAxis/HBoxContainer/PanelContainer2/MarginContainer/InvertYOnBtn
@onready var invert_x_off_btn = $PanelContainer/MarginContainer/VBoxContainer/InvertXAxis/HBoxContainer/PanelContainer/MarginContainer/InvertXOffBtn
@onready var invert_x_on_btn = $PanelContainer/MarginContainer/VBoxContainer/InvertXAxis/HBoxContainer/PanelContainer2/MarginContainer/InvertXOnBtn

var options = ["ENGLISH", "ไทย"]
var index := 0
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = GameController
	update_label()
	update_invert_y_buttons()
	update_invert_x_buttons()
	
func apply_language():
	pass

func update_label():
	language_label.text = options[index]

func _on_left_language_btn_pressed() -> void:
	index -= 1
	if index < 0:
		index = options.size() - 1
	update_label()
	apply_language()

func _on_right_language_btn_pressed() -> void:
	index += 1
	if index >= options.size():
		index = 0
	update_label()
	apply_language()

func _on_mc_sensitivity_slider_value_changed(value: float) -> void:
	mc_sensitivity_number_label.text = str(value)
	player.mouse_sensitivity = value

func _on_invert_y_off_btn_pressed() -> void:
	player.invert_camera_y_axis = false
	update_invert_y_buttons()

func _on_invert_y_on_btn_pressed() -> void:
	player.invert_camera_y_axis = true
	update_invert_y_buttons()
	
func update_invert_y_buttons():
	if player.invert_camera_y_axis:
		invert_y_on_btn.modulate = Color(0.4, 1.0, 0.4)  
		invert_y_off_btn.modulate = Color(0.5, 0.5, 0.5)
	else:
		invert_y_off_btn.modulate = Color(0.4, 1.0, 0.4)
		invert_y_on_btn.modulate = Color(0.5, 0.5, 0.5)

func _on_invert_x_off_btn_pressed() -> void:
	player.invert_camera_x_axis = false
	update_invert_x_buttons()

func _on_invert_x_on_btn_pressed() -> void:
	player.invert_camera_x_axis = true
	update_invert_x_buttons()

func update_invert_x_buttons():
	if player.invert_camera_x_axis:
		invert_x_on_btn.modulate = Color(0.4, 1.0, 0.4)  
		invert_x_off_btn.modulate = Color(0.5, 0.5, 0.5)
	else:
		invert_x_off_btn.modulate = Color(0.4, 1.0, 0.4)
		invert_x_on_btn.modulate = Color(0.5, 0.5, 0.5)
