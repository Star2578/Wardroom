extends StaticBody3D

class_name Interactable 

@export_file("*.tscn") var item_scene_path: String 

func interact():
	# ส่ง item_scene_path ไปให้คำสั่ง inspect_menu นำมาแสดงโชว์
	if item_scene_path != "":
		InspectMenu.open_inspect(item_scene_path)
	else:
		print("Error: ลืมใส่ Path ของไอเทมใน Inspector!")
