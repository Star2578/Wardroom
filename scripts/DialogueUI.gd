extends CanvasLayer

@onready var name_label = $Panel/NameLabel
@onready var text_label = $Panel/TextLabel
@onready var choice_container = $Panel/ChoiceContainer

var dialogue_data = {}
var current_node = ""
var player_ref = null

func _ready():
	hide()

func start_dialogue(data, player):
	dialogue_data = data["nodes"]
	player_ref = player
	show()
	go_to_node("start")

func go_to_node(node_id):
	current_node = node_id
	var node = dialogue_data[node_id]
	
	name_label.text = node["name"]
	text_label.text = node["text"]
	
	clear_choices()
	
	if node.has("choices"):
		show_choices(node["choices"])
	else:
		# ถ้าไม่มี choice แปลว่าจบ
		await get_tree().create_timer(5).timeout
		end_dialogue()

func show_choices(choices):
	choice_container.show()
	
	for choice in choices:
		var btn = Button.new()
		btn.text = choice["text"]
		btn.pressed.connect(func():
			go_to_node(choice["next"])
		)
		choice_container.add_child(btn)

func clear_choices():
	for child in choice_container.get_children():
		child.queue_free()
	choice_container.hide()

func end_dialogue():
	hide()
	player_ref.can_move = true
