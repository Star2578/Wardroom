extends Interactable

@export var flushable: bool = true
@onready var flush_sfx: AudioStreamPlayer3D = $"../../AudioStreamPlayer3D"

func interact():
	if flushable and not flush_sfx.playing:
		flush_sfx.play()
	
	if not flushable:
		GameController.text_writer.play_text("TOILET_002")
		
