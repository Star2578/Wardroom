extends VBoxContainer

@onready var volume_number_label = $PanelContainer/MarginContainer/VBoxContainer/MasterVolume/HBoxContainer/PanelContainer/VolumeNumberLabel
@onready var volume_slider = $PanelContainer/MarginContainer/VBoxContainer/MasterVolume/HBoxContainer/PanelContainer2/VolumeSlider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _on_volume_slider_value_changed(value: float) -> void:
	var volume_number = int(value)
	volume_number_label.text = str(volume_number)
	
	if value <= 0.0:
		GameController.master_volume_db = 0.0
	else:
		GameController.master_volume_db = linear_to_db(value / 100)
	GameController.apply_audio_settings()
