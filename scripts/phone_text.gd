extends Node3D

@export var messages_json_file: String
var phone_data: Dictionary

@export var chat_bubble_scene: PackedScene
@onready var chat_bubble_container: VBoxContainer = $"Screen/SubViewport/CanvasLayer/WhiteBG/ScrollContainer/VBoxContainer"
@onready var message_sfx: AudioStreamPlayer = $"MessageSFX"

@export var scroll_container: ScrollContainer

@export var wait: ColorRect
@export var choice1: ColorRect
@export var choice1_text: Label
@export var choice2: ColorRect
@export var choice2_text: Label

var current_branch = "start"
var current_index = 0

func _ready():
	_load_json_data()
	for child in chat_bubble_container.get_children():
		child.queue_free()

func _load_json_data():
	var file = FileAccess.open(messages_json_file, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		phone_data = JSON.parse_string(json_string)
		file.close()

func next_message():
	var branch_data = phone_data.get(current_branch, {})
	var sequence = branch_data.get("sequence", [])

	print("Current branch: " + current_branch + ", Current index: " + str(current_index), " Sequence size: " + str(sequence.size()))

	# Check if we still have messages in the current sequence
	if current_index < sequence.size():
		wait.show()
		var msg_data = sequence[current_index]
		_spawn_chat_bubble(msg_data["text"], msg_data["sender"])
		current_index += 1

		var timer = Timer.new()
		timer.wait_time = 1.5
		timer.one_shot = true
		add_child(timer)
		timer.start()
		timer.timeout.connect(next_message)

	else:
		# Check if there are choices to display
		var choices = branch_data.get("choices", [])
		if choices.size() > 0:
			_show_choice_buttons(choices)
		else:
			print("End of conversation.")

func _spawn_chat_bubble(text, sender):
	var chat_bubble = chat_bubble_scene.instantiate()
	chat_bubble.set_text(text)
	# Logic to change side/color based on "g" or "s"
	var color = 0 if sender == "g" else 1 
	chat_bubble.set_color(color)
	chat_bubble_container.add_child(chat_bubble)
	chat_bubble.set_direction(0 if sender == "g" else 1)

	message_sfx.play()

	scroll_to_bottom()

func _show_choice_buttons(choices):
	wait.hide()
	choice1_text.text = "[1] " + choices[0]["text"]
	choice1.show()
	if choices.size() > 1:
		choice2_text.text = "[2] " + choices[1]["text"]
		choice2.show()

# Call this when a player clicks a choice button
func select_choice(choice: String):
	var next_branch_key = ""
	if choice == "choice1" and choice1.is_visible():
		next_branch_key = phone_data[current_branch]["choices"][0]["next"]
	elif choice == "choice2" and choice2.is_visible():
		next_branch_key = phone_data[current_branch]["choices"][1]["next"]
	else:
		print("Invalid choice selected.")
		return
	print("Selected choice: " + choice + ", Next branch: " + next_branch_key)

	choice1.hide()
	choice2.hide()
	wait.show()

	current_branch = next_branch_key
	current_index = 0
	next_message()

func scroll_to_bottom():
	await get_tree().process_frame
	
	scroll_container.set_v_scroll(int(scroll_container.get_v_scroll_bar().max_value))
