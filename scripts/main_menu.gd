extends Control

@export var animation : AnimationPlayer

@onready var start_btn = $Start
@onready var option_btn = $Option
@onready var quit_btn = $Quit
@onready var option_panel = $"../Option2"

func _on_start_pressed() -> void:
	$"../CutscenePlayer".next_shot()
	start_btn.disabled = true
	option_btn.disabled = true
	quit_btn.disabled = true


func _on_option_pressed() -> void:
	visible = false
	option_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()

func change_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/test_map.tscn")
