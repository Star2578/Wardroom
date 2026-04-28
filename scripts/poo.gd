extends Interactable

var has_key: bool = false
@export var key: String = "" # blank = no key

func interact():
	has_key = GameController.got_plunger
	if not has_key:
		GameController.text_writer.play_text("Some people are the worse...")
	else:
		GameController.got_plunger = false
		# TODO : Summon Key
		queue_free()