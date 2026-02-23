extends StaticBody3D

@export var item_data: ItemData

func interact():
	InventoryManager.add_item(item_data)
	queue_free() # ของหายไปจากโลก
