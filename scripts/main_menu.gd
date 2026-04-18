extends Control

@export var animation : AnimationPlayer

@onready var start_btn = $Start
@onready var option_btn = $Option
@onready var quit_btn = $Quit
@onready var cutscene_player = $"../CutscenePlayer"

func _ready() -> void:
	GameController.main_menu = self
	# Main menu must always show cursor for UI interaction.
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_start_pressed() -> void:
	GameController.is_started = true
	GameController.main_menu = null
	$"../CutscenePlayer".next_shot()
	start_btn.disabled = true
	option_btn.disabled = true
	quit_btn.disabled = true


func _on_option_pressed() -> void:
	GameController.toggle_options_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

func change_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
