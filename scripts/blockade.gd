extends Interactable


@export var is_locked: bool = false
@export var key: String = ""
@export var warn: String = "This door is locked"

@onready var cut_sfx = "res://sounds/sfx/freesound-community-scissors-69248_cO9Psqaq.mp3"

var has_locked = false

func interact():
	var has_scissors = GameController.got_scissors
	
	if is_locked and not has_scissors:
		GameController.text_writer.play_text(warn)
	else:
		var sfx_player = AudioStreamPlayer3D.new()
		get_tree().root.add_child(sfx_player)

		sfx_player.stream = load(cut_sfx)
		sfx_player.global_position = global_position
		sfx_player.play()

		sfx_player.finished.connect(sfx_player.queue_free)

		queue_free()
