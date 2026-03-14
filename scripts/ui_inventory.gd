extends CanvasLayer

@onready var grid = $Panel/ItemGrid
@onready var description = $Panel/DescriptionLabel

func _ready():
	hide()

func toggle():
	visible = !visible
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

		slot.mouse_entered.connect(func():
			description.text = item.description
		)

		slot.mouse_exited.connect(func():
			description.text = ""
		)

		grid.add_child(slot)
