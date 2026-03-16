extends Control
class_name TextWriter

@export var json_path: String

@onready var rich_label = $RichTextLabel
@onready var sfx_player = $AudioStreamPlayer

var dialogue_data: Dictionary = {}
var current_index = 0
var current_cs = ""
var typing_speed = 0.05 # Seconds per character
var active_tween: Tween
var text_paused: bool = false

func _ready():
	dialogue_data = load_dialogue_from_json(json_path)

func load_dialogue_from_json(file_path: String):
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file.get_length() > 0:
			var content = file.get_as_text()
			var parse_result = JSON.parse_string(content)
			if parse_result is Dictionary:
				dialogue_data = parse_result
				print(dialogue_data)
				print(dialogue_data.size())
		file.close()
	return dialogue_data

func set_dialogue_cs(cs_code: String):
	current_cs = cs_code

func show_next_dialogue():
	if current_index >= dialogue_data[current_cs].size():
		rich_label.text = "" # End of dialogue
		return

	# 1. Set the text
	rich_label.text = dialogue_data[current_cs][current_index]
	current_index += 1
	
	# 2. Reset visibility and animate
	rich_label.visible_ratio = 0
	
	var duration = rich_label.text.length() * typing_speed
	if active_tween:
		active_tween.kill()
		active_tween = null

	active_tween = create_tween()
	
	# Interpolate the visible_ratio property from 0 to 1
	active_tween.tween_property(rich_label, "visible_ratio", 1.0, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	# play sounds and stop when tween is done
	sfx_player.play()
	active_tween.finished.connect(_on_text_tween_finished)


func pause_text() -> void:
	if active_tween and active_tween.is_running():
		active_tween.pause()
		text_paused = true

	if sfx_player.playing:
		sfx_player.stop()


func resume_text() -> void:
	if not text_paused:
		return

	if active_tween:
		active_tween.play()
		if sfx_player.stream:
			sfx_player.play()

	text_paused = false


func _on_text_tween_finished() -> void:
	sfx_player.stop()
	active_tween = null
	text_paused = false
