extends CanvasLayer

@onready var name_label = $NameLabel
@onready var prompt_label = $PromptLabel

func _ready() -> void:
	hide()
	
func set_target(target):
	if target == null:
		hide()
		return

	var data = target.get_interaction_data()
	name_label.text = data.get("name", "Object Name")
	prompt_label.text = data.get("prompt", "Press E")
	show()
