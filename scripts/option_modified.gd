extends Control

@onready var description_name = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Description/MarginContainer/VBoxContainer/NameLabel
@onready var description_label = $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/Description/MarginContainer/VBoxContainer/DescriptionLabel

var tabs = {}

func _ready() -> void:
	tabs = {
		"video": $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/VideoContainer,
		"gameplay": $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/GameplayContainer,
		"controls": $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/ControlsContainer,
		"audio": $PanelContainer/MarginContainer/VBoxContainer/MarginContainer/HBoxContainer/AudioContainer
	}
	
	show_tab("video")  # default
	
	for item in get_tree().get_nodes_in_group("setting_items"):
		item.hovered.connect(_on_item_hovered)
	
func show_tab(tab_name):
	for t in tabs.values():
		t.visible = false
		
	tabs[tab_name].visible = true
	
func _on_video_btn_pressed():
	show_tab("video")
	
func _on_gameplay_btn_pressed():
	show_tab("gameplay")
	
func _on_controls_btn_pressed():
	show_tab("controls")
	
func _on_audio_btn_pressed():
	show_tab("audio")
	
func _on_item_hovered(setting_name, setting_desc):
	description_name.text = setting_name
	description_label.text = setting_desc
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
