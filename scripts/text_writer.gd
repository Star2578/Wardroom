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
var fade_out_tween: Tween
@export var fade_out: bool = false

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


func _on_text_tween_finished():
	sfx_player.stop()
	active_tween = null

	fade_out_tween = create_tween()
	fade_out_tween.tween_interval(2.0)
	fade_out_tween.tween_property(rich_label, "modulate", Color(1, 1, 1, 0), 1)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	

func play_text(text: String):
	if active_tween:
		active_tween.kill()
		active_tween = null
	
	if fade_out:
		if fade_out_tween:
			fade_out_tween.kill()
			fade_out_tween = null
			
	rich_label.visible_ratio = 0
	rich_label.modulate = Color(1, 1, 1, 1) # Reset modulate to fully visible
	rich_label.text = text
	
	var duration = rich_label.text.length() * typing_speed

	active_tween = create_tween()
	
	# Interpolate the visible_ratio property from 0 to 1
	active_tween.tween_property(rich_label, "visible_ratio", 1.0, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
	# play sounds and stop when tween is done
	sfx_player.play()
	active_tween.finished.connect(_on_text_tween_finished)

