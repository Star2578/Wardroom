extends PanelContainer

var normal_style: StyleBoxFlat
var hover_style: StyleBoxFlat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_create_styles()
	mouse_entered.connect(_on_hover)
	mouse_exited.connect(_on_exit)
	
func _create_styles():
	# NORMAL
	normal_style = StyleBoxFlat.new()
	normal_style.bg_color = Color(0.27, 0.27, 0.27, 0.1)
	normal_style.border_width_bottom = 1
	normal_style.border_width_top = 1
	normal_style.border_width_left = 1
	normal_style.border_width_right = 1
	normal_style.border_color = Color(0.3, 0.3, 0.3)
	normal_style.set_corner_radius_all(4)

	# HOVER
	hover_style = StyleBoxFlat.new()
	hover_style.bg_color = Color(0.3, 0.3, 0.3, 0.2)
	hover_style.border_width_bottom = 1
	hover_style.border_width_top = 1
	hover_style.border_width_left = 1
	hover_style.border_width_right = 1
	hover_style.border_color = Color(0.6, 0.6, 0.6) # light blue highlight
	hover_style.set_corner_radius_all(4)

	# Apply default
	add_theme_stylebox_override("panel", normal_style)
	

func _on_hover():
	add_theme_stylebox_override("panel", hover_style)

func _on_exit():
	add_theme_stylebox_override("panel", normal_style)
