extends Interactable

@export var change_to_scene: String
@export var player: Node3D

var is_interacted = false

func get_interaction_data() -> Dictionary:
	return {
		"name": object_data.name,
		"prompt": "Press E to Consume"
	}

func interact():
	if not is_interacted:
		is_interacted = true
		%EatSFX.play()
		GameController.cutscene_player.next_shot()

func change_to():
	get_tree().change_scene_to_file(change_to_scene)
