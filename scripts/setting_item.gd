extends PanelContainer

@export var ui_data: UIData

signal hovered(setting_name, setting_desc)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	mouse_entered.connect(_on_hover)

func _on_hover():
	emit_signal("hovered", ui_data.name, ui_data.description)
	
