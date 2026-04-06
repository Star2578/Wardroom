extends Interactable

var has_key: bool = false
@export var key: String = "" # blank = no key

func interact():
	if not has_key:
		GameController.text_writer.play_text("Some people are the worse...")