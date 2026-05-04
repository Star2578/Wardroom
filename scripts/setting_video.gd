extends VBoxContainer

@onready var mode_label = $PanelContainer/MarginContainer/VBoxContainer/WindowMode/HBoxContainer/HBoxContainer/PanelContainer/ModeLabel

@onready var gamma_number_label = $PanelContainer/MarginContainer/VBoxContainer/Gamma/HBoxContainer/PanelContainer/GammaNumberLabel
@onready var gamma_slider = $PanelContainer/MarginContainer/VBoxContainer/Gamma/HBoxContainer/PanelContainer2/GammaSlider

var options = ["FULL_SCREEN", "WINDOWED"]
var index := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_label()

func update_label():
	mode_label.text = options[index]

func apply_mode():
	match options[index]:
		"WINDOWED":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		"FULL_SCREEN":
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

func _on_gamma_slider_value_changed(value: float) -> void:
	gamma_number_label.text = str(value)
	
	GameController.brightness = value
	GameController.apply_brightness_settings()
	
func _on_left_mode_btn_pressed() -> void:
	index -= 1
	if index < 0:
		index = options.size() - 1
	update_label()
	apply_mode()

func _on_right_mode_btn_pressed() -> void:
	index += 1
	if index >= options.size():
		index = 0
	update_label()
	apply_mode()
