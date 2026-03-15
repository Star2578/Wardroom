extends SubViewportContainer

@export var pivot: Node3D
@export var rotation_speed: float = 0.5

var dragging = false

func _gui_input(event):
	# Start dragging when clicking inside the UI area
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		dragging = event.pressed

	# Rotate the pivot based on mouse relative motion
	if event is InputEventMouseMotion and dragging:
		pivot.rotate_y(deg_to_rad(event.relative.x * rotation_speed))
		pivot.rotate_x(deg_to_rad(event.relative.y * rotation_speed))
