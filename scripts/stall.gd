extends Interactable

@onready var anim_player: AnimationPlayer = $"../../AnimationPlayer"
var is_open: bool = false

func interact():
	toggle_door()

func toggle_door():
	if not is_open:
		anim_player.play("open", -1, 1.0)
		is_open = true
	else:
		anim_player.play("open", -1, -1.0, true)
		is_open = false
