extends Node

var items: Array[ItemData] = []

func add_item(item: ItemData):
	items.append(item)
	print("Added:", item.item_name)

func remove_item(item: ItemData):
	items.erase(item)

func has_item(item_name: String) -> bool:
	for i in items:
		if i.item_name == item_name:
			return true
	return false
