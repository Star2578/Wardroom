extends Control
class_name TextWriter

@export var json_path: String

@onready var rich_label = $RichTextLabel

var dialogue_data: Dictionary = {}
var current_index = 0
var current_cs = ""
var typing_speed = 0.05 # Seconds per character

func _ready():
	dialogue_data = load_dialogue_from_json(json_path)

func load_dialogue_from_json(file_path: String):
	var dialogue_data = {}
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
	if current_index >= dialogue_data.size():
		rich_label.text = "" # End of dialogue
		return

	# 1. Set the text
	rich_label.text = dialogue_data[current_cs][current_index]
	current_index += 1
	
	# 2. Reset visibility and animate
	rich_label.visible_ratio = 0
	
	var duration = rich_label.text.length() * typing_speed
	var tween = create_tween()
	
	# Interpolate the visible_ratio property from 0 to 1
	tween.tween_property(rich_label, "visible_ratio", 1.0, duration)\
		.set_trans(Tween.TRANS_LINEAR)\
		.set_ease(Tween.EASE_IN_OUT)
