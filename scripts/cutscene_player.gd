extends Node

class_name CutscenePlayer

@export var shots : Array[String]
@export var anim : AnimationPlayer
@export var text_writer : TextWriter

var current_index = 0
var current_shot : String
var cutscene_pause: bool = false

func _ready() -> void:
	GameController.cutscene_player = self
	text_writer.set_dialogue_cs(shots[0])

func next_shot():
	if current_index > shots.size():
		print("Cutscene Finished")
		return
	
	current_shot = shots[current_index]

	print("Playing shot: " + current_shot)
	
	anim.play(current_shot)
	current_index += 1
	text_writer.set_dialogue_cs(current_shot)
	text_writer.current_index = 0
