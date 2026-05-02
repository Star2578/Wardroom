extends VBoxContainer

@onready var volume_number_label = $PanelContainer/MarginContainer/VBoxContainer/MasterVolume/HBoxContainer/PanelContainer/VolumeNumberLabel
@onready var volume_slider = $PanelContainer/MarginContainer/VBoxContainer/MasterVolume/HBoxContainer/PanelContainer2/VolumeSlider
@onready var music_number_label = $PanelContainer/MarginContainer/VBoxContainer/Music/HBoxContainer/PanelContainer/MusicNumberLabel
@onready var music_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/Music/HBoxContainer/PanelContainer2/MusicVolumeSlider
@onready var sfx_number_label = $PanelContainer/MarginContainer/VBoxContainer/SFX/HBoxContainer/PanelContainer/SFXNumberLabel
@onready var sfx_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/SFX/HBoxContainer/PanelContainer2/SFXVolumeSlider
@onready var dialogue_number_label = $PanelContainer/MarginContainer/VBoxContainer/Dialogue/HBoxContainer/PanelContainer/DialogueNumberLabel
@onready var dialogue_volume_slider = $PanelContainer/MarginContainer/VBoxContainer/Dialogue/HBoxContainer/PanelContainer2/DialogueVolumeSlider

var master_bus_index = AudioServer.get_bus_index("Master")
var music_bus_index = AudioServer.get_bus_index("Music")
var sfx_bus_index = AudioServer.get_bus_index("SFX")
var dialogue_bus_index = AudioServer.get_bus_index("Dialogue")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioServer.set_bus_volume_db(master_bus_index, linear_to_db(volume_slider.value / 100))
	AudioServer.set_bus_volume_db(music_bus_index, linear_to_db(music_volume_slider.value / 100))
	AudioServer.set_bus_volume_db(sfx_bus_index, linear_to_db(sfx_volume_slider.value / 100))
	AudioServer.set_bus_volume_db(dialogue_bus_index, linear_to_db(dialogue_volume_slider.value / 100))

func _on_volume_slider_value_changed(value: float) -> void:
	var volume_number = int(value)
	volume_number_label.text = str(volume_number)
	
	if value <= 0.0:
		volume_number = -80.0
	else:
		volume_number = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(master_bus_index, volume_number)

func _on_music_volume_slider_value_changed(value: float) -> void:
	var volume_number = int(value)
	music_number_label.text = str(volume_number)
	
	if value <= 0.0:
		volume_number = -80.0
	else:
		volume_number = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(music_bus_index, volume_number)

func _on_sfx_volume_slider_value_changed(value: float) -> void:
	var volume_number = int(value)
	sfx_number_label.text = str(volume_number)
	
	if value <= 0.0:
		volume_number = -80.0
	else:
		volume_number = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(sfx_bus_index, volume_number)
	
func _on_dialogue_volume_slider_value_changed(value: float) -> void:
	var volume_number = int(value)
	dialogue_number_label.text = str(volume_number)
	
	if value <= 0.0:
		volume_number = -80.0
	else:
		volume_number = linear_to_db(value / 100)
	AudioServer.set_bus_volume_db(dialogue_bus_index, volume_number)
