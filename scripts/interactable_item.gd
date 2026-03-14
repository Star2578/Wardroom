extends Interactable

func get_interaction_data() -> Dictionary:
	return {
		"name": object_data.name,
		"prompt": "Press E to pick up"
	}

func interact():
	InventoryManager.add_item(object_data)	
	queue_free() # ของหายไปจากโลก
