extends VBoxContainer

@onready var language_label = $PanelContainer/MarginContainer/VBoxContainer/Language/HBoxContainer/HBoxContainer/PanelContainer/LanguageLabel

@onready var mc_sensitivity_number_label = $PanelContainer/MarginContainer/VBoxContainer/MouseCameraSensitivity/HBoxContainer/PanelContainer/MCSensitivityNumberLabel
@onready var mc_sensitivity_slider = $PanelContainer/MarginContainer/VBoxContainer/MouseCameraSensitivity/HBoxContainer/PanelContainer2/MCSensitivitySlider

var options = ["ENGLISH", "ไทย"]
var index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()
	
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
	GameController.mouse_sensitivity = value
