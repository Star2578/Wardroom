extends Interactable

@onready var red_key: PackedScene = preload("res://scenes/interactable_objects/red_key.tscn")
var plunger_sfx = "res://sounds/sfx/spinopel-toilet-sucker-plunger-411655.mp3"

var has_key: bool = false
@export var key: String = "" # blank = no key

func interact():
	has_key = GameController.got_plunger
	if not has_key:
		GameController.text_writer.play_text("TOILET_001")
	else:
		GameController.got_plunger = false
		var rk: Interactable = red_key.instantiate()
		get_tree().root.add_child(rk)
		rk.global_position = global_position
		rk.scale = Vector3.ONE * 2

		var sfx_player = AudioStreamPlayer3D.new()
		get_tree().root.add_child(sfx_player)
		
		sfx_player.stream = load(plunger_sfx)
		sfx_player.global_position = global_position
		sfx_player.play()
		
		sfx_player.finished.connect(sfx_player.queue_free)
		
		queue_free()
