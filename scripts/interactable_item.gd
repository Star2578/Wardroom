extends Interactable

@onready var pick_up_sfx = "res://sounds/sfx/swipe.wav"

func get_interaction_data() -> Dictionary:
	return {
		"name": object_data.name,
		"prompt": "Press E to pick up"
	}

func interact():
	InventoryManager.add_item(object_data)	

	if object_data.name == "Phone":
		GameController.got_phone = true
	if object_data.name == "Plunger":
		GameController.got_plunger = true
	if object_data.name == "Scissors":
		GameController.got_scissors = true
	
	var sfx_player = AudioStreamPlayer3D.new()
	get_tree().root.add_child(sfx_player)
	
	sfx_player.stream = load(pick_up_sfx)
	sfx_player.global_position = global_position
	sfx_player.play()
	
	sfx_player.finished.connect(sfx_player.queue_free)

	queue_free()
