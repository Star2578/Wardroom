extends Node


@export var shots : Array[String]
@export var anim : AnimationPlayer
@export var text_writer : TextWriter

var current_index = 0
var current_shot : String
var cutscene_pause: bool = false

func _ready() -> void:
	text_writer.set_dialogue_cs(shots[0])

func next_shot():
	if current_index > shots.size():
		print("Cutscene Finished")
		return
	
	current_shot = shots[current_index]
	
	anim.play(current_shot)
	current_index += 1
	text_writer.set_dialogue_cs(current_shot)
	text_writer.current_index = 0


func pause_cutscene() -> void:
	if anim == null or not anim.is_playing():
		return

	anim.pause()
	if text_writer and text_writer.has_method("pause_text"):
		text_writer.pause_text()
	cutscene_pause = true


func resume_cutscene() -> void:
	if not cutscene_pause or anim == null:
		return

	anim.play()
	if text_writer and text_writer.has_method("resume_text"):
		text_writer.resume_text()
	cutscene_pause = false
