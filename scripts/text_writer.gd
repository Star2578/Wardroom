extends Control
class_name TextWriter

@export var json_path: String

@onready var rich_label = $RichTextLabel
@onready var sfx_player = $AudioStreamPlayer

var dialogue_data: Dictionary = {}
var current_index: int = 0
var current_cs: String = ""

var current_dialogue_key: String = ""  # 🔥 important

var typing_speed = 0.05
var active_tween: Tween
var fade_out_tween: Tween
@export var fade_out: bool = false


# =========================
# READY
# =========================
func _ready():
	dialogue_data = load_dialogue_from_json(json_path)

	# listen for language change
	if GameController.has_signal("language_changed"):
		GameController.language_changed.connect(_on_language_changed)


# =========================
# LOAD JSON
# =========================
func load_dialogue_from_json(file_path: String) -> Dictionary:
	if FileAccess.file_exists(file_path):
		var file = FileAccess.open(file_path, FileAccess.READ)
		if file.get_length() > 0:
			var content = file.get_as_text()
			var result = JSON.parse_string(content)
			if result is Dictionary:
				file.close()
				return result
		file.close()
	return {}


# =========================
# CUTSCENE CONTROL
# =========================
func set_dialogue_cs(cs_code: String):
	current_cs = cs_code
	current_index = 0


func show_next_dialogue():
	if not dialogue_data.has(current_cs):
		push_error("Invalid cutscene key: " + current_cs)
		return

	if current_index >= dialogue_data[current_cs].size():
		rich_label.text = ""
		return

	var key = dialogue_data[current_cs][current_index]
	current_index += 1

	_show_text(key)


# =========================
# ONE-SHOT TEXT (INTERACT)
# =========================
func play_text(text_key: String):
	_show_text(text_key)


# =========================
# CORE DISPLAY FUNCTION
# =========================
func _show_text(text_key: String):
	# stop old tween
	if active_tween:
		active_tween.kill()
		active_tween = null

	if fade_out and fade_out_tween:
		fade_out_tween.kill()
		fade_out_tween = null

	current_dialogue_key = text_key

	rich_label.visible_ratio = 0
	rich_label.modulate = Color(1,1,1,1)

	# 🔥 translate here
	rich_label.text = tr(text_key)

	var duration = rich_label.text.length() * typing_speed

	active_tween = create_tween()
	active_tween.tween_property(rich_label, "visible_ratio", 1.0, duration)

	sfx_player.play()
	active_tween.finished.connect(_on_text_tween_finished)


# =========================
# TWEEN FINISHED
# =========================
func _on_text_tween_finished():
	sfx_player.stop()
	active_tween = null

	if fade_out:
		fade_out_tween = create_tween()
		fade_out_tween.tween_interval(2.0)
		fade_out_tween.tween_property(rich_label, "modulate", Color(1,1,1,0), 1)


# =========================
# LANGUAGE UPDATE
# =========================
func _on_language_changed():
	if current_dialogue_key != "":
		rich_label.text = tr(current_dialogue_key)
		rich_label.visible_ratio = 1.0  # prevent retyping glitch
