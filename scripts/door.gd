extends Node3D

class_name Door

@export var destination: Node3D
@export var fade_duration: float = 0.5

@onready var door_sfx: AudioStreamPlayer = $"../DoorSFX"
@onready var fade_black: ColorRect = $"../Control/FadeBlack"

func _ready():
	fade_black.modulate.a = 0
	fade_black.hide()

func interact():
	print("interact door")
	fade_black.show()
	
	var tween = create_tween()
	
	door_sfx.play()
	tween.tween_property(fade_black, "modulate:a", 1.0, fade_duration)
	
	tween.tween_callback(func():
		GameController.player.global_position = destination.global_position
	)
	
	tween.tween_property(fade_black, "modulate:a", 0.0, fade_duration)
	
	tween.tween_callback(fade_black.hide)
