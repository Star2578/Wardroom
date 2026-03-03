extends Pickable

@export var item_data: ItemData

func show_item():
	print("Showing item")

func interact():
	InventoryManager.add_item(item_data)
	queue_free() # ของหายไปจากโลก
