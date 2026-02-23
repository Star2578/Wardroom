extends Control

@onready var language_option: OptionButton = $MarginContainer/VBoxContainer/VolumeRow2/OptionButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if language_option.item_count == 0:
		language_option.add_item("English")
		language_option.add_item("Thai")
	language_option.select(0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(0, value)

func _on_check_box_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
