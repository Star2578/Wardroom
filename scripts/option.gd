extends Control

class_name Option

# soundcheck.mp3
const SOUNDCHECK_PATH := "uid://yfrcsc1kgiqr"

var soundcheck_player: AudioStreamPlayer

func _ready() -> void:
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_back_pressed() -> void:
	GameController.toggle_options_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_menu_pressed() -> void:
	var current_scene := get_tree().current_scene

	if current_scene and current_scene.scene_file_path == "res://scenes/main_menu.tscn":
		_on_back_pressed()
		return
	
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameController.return_from_option()


func _on_option_pressed() -> void:
	GameController.options_menu.visible = false
	GameController.option.visible = true
