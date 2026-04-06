extends Node

var items: Array[ObjectData] = []

func add_item(item: ObjectData):
	items.append(item)
	print("Added:", item.name)

func remove_item(item: ObjectData):
	items.erase(item)

func remove_item_by_name(item_name: String):
	for i in items:
		if i.name == item_name:
			items.erase(i)
			print("Removed:", item_name)
			return
	print("Item not found:", item_name)

func has_item(item_name: String) -> bool:
	for i in items:
		if i.name == item_name:
			return true
	return false

func check_key_for_door(door: Door) -> bool:
	if door.is_locked and has_item(door.key):
		return true
	return false