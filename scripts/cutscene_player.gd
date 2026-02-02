extends Node


@export var shots : Array[String]
@export var anim : AnimationPlayer

var current_index = 0

func next_shot():
	if current_index > shots.size():
		print("Cutscene Finished")
		return
	
	anim.play(shots[current_index])
	current_index += 1
