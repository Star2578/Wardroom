extends Node3D

@export_file("*.json") var dialogue_file_path: String

@onready var dialogue_ui = $"../UI/DialogueUI"
@onready var player = $"../ProtoController"

func interact():
	var dialogue_data = load_dialogue(dialogue_file_path)
	dialogue_ui.start_dialogue(dialogue_data, player)
	
	
func load_dialogue(path: String):
	var file = FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open file:", path)
		return {}
		
	var content = file.get_as_text()
	file.close()
	
	var json = JSON.new()
	var result = json.parse(content)
	
	if result != OK:
		print("JSON Parse Error")
		return {}
		
	return json.data
