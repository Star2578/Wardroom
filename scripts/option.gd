extends Control

@onready var language_option: OptionButton = $MarginContainer/VBoxContainer/VolumeRow2/OptionButton
@onready var mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/VolumeRow/CheckBox
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/VolumeRow/Volume

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if language_option.item_count == 0:
		language_option.add_item("English")
		language_option.add_item("Thai")
	language_option.select(0)
	volume_slider.value = GameController.master_volume_db
	mute_checkbox.button_pressed = GameController.master_muted
	GameController.apply_audio_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	GameController.master_volume_db = value
	GameController.apply_audio_settings()

func _on_check_box_toggled(toggled_on: bool) -> void:
	GameController.master_muted = toggled_on
	GameController.apply_audio_settings()

func _on_brightness_value_changed(value: float) -> void:
	GameController.brightness = value
	GameController.apply_brightness_settings()

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
