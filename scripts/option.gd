extends Control

# soundcheck.mp3
const SOUNDCHECK_PATH := "uid://yfrcsc1kgiqr"

@onready var language_option: OptionButton = $MarginContainer/VBoxContainer/VolumeRow2/OptionButton
@onready var mute_checkbox: CheckBox = $MarginContainer/VBoxContainer/VolumeRow/Mute
@onready var volume_slider: HSlider = $MarginContainer/VBoxContainer/VolumeRow/Volume
@onready var brightness_slider: HSlider = $MarginContainer/VBoxContainer/VolumeRow3/Brightness

var soundcheck_player: AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if language_option.item_count == 0:
		language_option.add_item("English")
		language_option.add_item("Thai")
	language_option.select(0)
	_setup_soundcheck_player()

	volume_slider.value = db_to_linear(GameController.master_volume_db)
	mute_checkbox.button_pressed = GameController.master_muted
	GameController.apply_audio_settings()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_volume_value_changed(value: float) -> void:
	if value <= 0.0:
		GameController.master_volume_db = -80.0
	else:
		GameController.master_volume_db = linear_to_db(value)
	GameController.apply_audio_settings()

func _on_mute_button_toggled(toggled_on: bool) -> void:
	GameController.master_muted = toggled_on
	GameController.apply_audio_settings()

func _on_volume_drag_ended(_value_changed: bool) -> void:
	if soundcheck_player and soundcheck_player.stream:
		soundcheck_player.play()

func _setup_soundcheck_player() -> void:
	soundcheck_player = AudioStreamPlayer.new()
	soundcheck_player.stream = load(SOUNDCHECK_PATH) as AudioStream
	add_child(soundcheck_player)

func _on_brightness_value_changed(value: float) -> void:
	GameController.brightness = value
	GameController.apply_brightness_settings()

func _on_back_pressed() -> void:
	var parent_node := get_parent()
	if parent_node and parent_node.has_node("MainMenu"):
		visible = false
		parent_node.get_node("MainMenu").visible = true
		return

	GameController.return_from_option()


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return

	if event.is_action_pressed("ui_cancel"):
		_on_back_pressed()
		get_viewport().set_input_as_handled()
