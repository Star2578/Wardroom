extends CanvasLayer

@export var grid : GridContainer
@export var nameLabel : Label
@export var ItemInspector : CanvasLayer

func _ready():
	hide()

func toggle():
	visible = !visible
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE if visible else Input.MOUSE_MODE_CAPTURED
	ItemInspector.hide()
	if visible:
		refresh()

func refresh():
	# ลบของเก่า
	for child in grid.get_children():
		child.queue_free()

	for item in InventoryManager.items:
		var slot = TextureRect.new()
		slot.texture = item.icon
		slot.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		slot.custom_minimum_size = Vector2(64, 64)

		slot.process_mode = Node.PROCESS_MODE_ALWAYS

		print("Adding item to inventory UI: ", item.name, " ", item.description)

		slot.mouse_entered.connect(func():
			nameLabel.text = item.name
		)

		slot.mouse_exited.connect(func():
			nameLabel.text = ""
		)

		slot.gui_input.connect(func(event):
			if event is InputEventMouseButton:
				if event.button_index == MouseButton.MOUSE_BUTTON_LEFT and event.pressed:
					print("Clicked on item: ", item.name)
					ItemInspector.set_mesh(item.mesh)
					ItemInspector.set_mesh_scale(item.mesh_scale)
					ItemInspector.set_description(item.description)
					ItemInspector.show()
				elif event.button_index == MouseButton.MOUSE_BUTTON_RIGHT and event.pressed:
					ItemInspector.hide()
		)

		grid.add_child(slot)
