extends Control

@export var animation : AnimationPlayer

@onready var start_btn = $"Press Any Key"
@onready var option_btn = $Option
@onready var quit_btn = $Quit
@onready var cutscene_player = $"../CutscenePlayer"

var started := false
var input_enabled := false

func _ready() -> void:
	GameController.main_menu = self
	# Main menu must always show cursor for UI interaction.
	await get_tree().create_timer(2.5).timeout
	input_enabled = true

func _on_start_pressed() -> void:
	GameController.is_started = true
	GameController.main_menu = null
	$"../CutscenePlayer".next_shot()
	start_btn.disabled = true
	option_btn.disabled = true
	quit_btn.disabled = true
	
func _input(event):
	if not input_enabled or started:
		return
		
	if event is InputEventKey and event.pressed:
		if event.keycode != KEY_ESCAPE:
			started = true
			_on_start_pressed()
		return
	
	if event is InputEventMouseButton and event.pressed:
		started = true
		_on_start_pressed()


func _on_option_pressed() -> void:
	GameController.toggle_options_menu()

func _on_quit_pressed() -> void:
	get_tree().quit()

func change_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
