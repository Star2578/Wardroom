extends Interactable

@onready var sfx: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var content: CanvasLayer = %Content
@onready var text: RichTextLabel = %RichTextLabel

func _ready():
	content.hide()
	text.text = object_data.description

func interact():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	content.show()
	sfx.play()

func close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	sfx.play()
	content.hide()
