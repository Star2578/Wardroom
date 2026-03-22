extends Interactable

@export var change_to_scene: String

func get_interaction_data() -> Dictionary:
	return {
		"name": object_data.name,
		"prompt": "Press E to Consume"
	}

func interact():
	get_tree().change_scene_to_file(change_to_scene)
