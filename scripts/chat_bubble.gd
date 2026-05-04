extends MarginContainer


@export var text: Label
@export var color1: NinePatchRect
@export var color2: NinePatchRect


func set_text(new_text: String):
	text.text = new_text

func set_color(index: int):
	# index: 0 for blue
	# index: 1 for gray
	if index == 0:
		color1.show()
		color2.hide()
	elif index == 1:
		color1.hide()
		color2.show()
	else:
		color1.hide()
		color2.hide()

func set_direction(dir: int):
	# dir: 0 for left (sender "g"), 1 for right (sender "s")
	if dir == 0:
		# Align to the left
		size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
	else:
		# Align to the right
		size_flags_horizontal = Control.SIZE_SHRINK_END
