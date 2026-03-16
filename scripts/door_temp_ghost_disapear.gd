extends Door

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
	
