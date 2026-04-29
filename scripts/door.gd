extends Node3D

class_name Door

@export var destination: Node3D
@export var fade_duration: float = 0.5
@export var temp_bool: bool

@onready var door_sfx: AudioStreamPlayer = $"../DoorSFX"
@onready var fade_black: ColorRect = $"../Control/FadeBlack"

@onready var ghost = get_node_or_null("../Ghost")

@export var is_locked: bool = false
@export var key: String = ""
@export var warn: String = "This door is locked"

func _ready():
	fade_black.modulate.a = 0
	fade_black.hide()

func interact():
	var has_key = InventoryManager.check_key_for_door(self)
	
	if is_locked and not has_key:
		print("door is locked")
		GameController.text_writer.play_text(warn)
		return
	else:
		InventoryManager.remove_item_by_name(key)

		if key == "Wardroom Key":
			get_tree().change_scene_to_file("res://scenes/end.tscn")
	
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
	
	if temp_bool == true:
		if ghost:
			print("ghost found")
			ghost.queue_free()
