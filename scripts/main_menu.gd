extends Control

@export var animation : AnimationPlayer

@onready var start_btn = $Start
@onready var option_btn = $Option
@onready var quit_btn = $Quit
@onready var option_panel = $"../Option2"
@onready var cutscene_player = $"../CutscenePlayer"

func _on_start_pressed() -> void:
	$"../CutscenePlayer".next_shot()
	start_btn.disabled = true
	option_btn.disabled = true
	quit_btn.disabled = true


func _on_option_pressed() -> void:
	if cutscene_player and cutscene_player.has_method("pause_cutscene"):
		cutscene_player.pause_cutscene()
	visible = false
	option_panel.visible = true


func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if option_panel and option_panel.visible:
		return
	if not event.is_action_pressed("ui_cancel"):
		return


	var viewport := get_viewport()
	if viewport:
		viewport.set_input_as_handled()

	_on_option_pressed()


func _on_quit_pressed() -> void:
	get_tree().quit()

func change_to_game() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
