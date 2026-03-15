extends Node3D

@export var horizontal_gimbal: Node3D
@export var vertical_gimbal: Node3D
@export var camera: Camera3D

const MAX_YAW = 100.0
const MAX_PITCH = 45.0

@onready var ray = $"Horizontal/Vertical/Camera/RayCast3D"
@onready var inventory_ui = $"UI/InventoryUI"

@onready var interaction_ui = $"UI/InteractableUI"

var current_target: Node = null

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	blink()

func _input(event):	
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED and !GameController.is_paused:
		# 1. Rotate the whole horizontal base (Yaw)
		horizontal_gimbal.rotate_y(-event.relative.x * GameController.mouse_sensitivity)
		
		# 2. Rotate the vertical gimbal (Pitch)
		vertical_gimbal.rotate_x(-event.relative.y * GameController.mouse_sensitivity)
		
		# 3. Clamp the Pitch (Vertical)
		vertical_gimbal.rotation.x = clamp(
			vertical_gimbal.rotation.x, 
			deg_to_rad(-20), 
			deg_to_rad(MAX_PITCH)
		)
		
		# 4. Clamp the Yaw (Horizontal)
		horizontal_gimbal.rotation.y = clamp(
			horizontal_gimbal.rotation.y, 
			deg_to_rad(-MAX_YAW), 
			deg_to_rad(MAX_YAW)
		)

	if event.is_action_pressed("inventory"):
		GameController.pause_game()
		inventory_ui.toggle()

func _process(_delta):
	_update_target()

func _get_raycast_target():
	if !ray or !ray.is_colliding():
		return null
	var obj = ray.get_collider()
	if obj and obj.has_method("get_interaction_data"):
		return obj
	return null

func _update_target():
	var target = _get_raycast_target()

	if target != current_target:
		current_target = target
		interaction_ui.set_target(current_target)  # UI handles show/hide + text

	if current_target and Input.is_action_just_pressed("interact"):
		interaction_ui.set_target(null)
		current_target.interact()

func blink():
	var tween = create_tween()
	
	# Fade in (alpha to 1)
	tween.tween_property($UserInterface/CanvasLayer/FadeOutBlink, "modulate:a", 1.0, 3)
	# Fade out (alpha to 0)
	tween.tween_property($UserInterface/CanvasLayer/FadeOutBlink, "modulate:a", 0.0, 2)
