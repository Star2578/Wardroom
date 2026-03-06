extends Node

var items: Array[ObjectData] = []

func add_item(item: ObjectData):
	items.append(item)
	print("Added:", item.name)

func remove_item(item: ObjectData):
	items.erase(item)

func has_item(item_name: String) -> bool:
	for i in items:
		if i.name == item_name:
			return true
	return false
