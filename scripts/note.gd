extends Interactable

@onready var sfx: AudioStreamPlayer3D = %AudioStreamPlayer3D
@onready var content: CanvasLayer = %Content
@onready var text: RichTextLabel = %RichTextLabel

var current_desc_key: String = ""

func _ready():
	content.hide()
	text.text = tr(object_data.description)
	GameController.language_changed.connect(_on_language_changed)

func _on_language_changed():
	if current_desc_key != "":
		text.text = tr(current_desc_key)
		
func interact():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	content.show()
	sfx.play()

	current_desc_key = object_data.description
	text.text = tr(current_desc_key)

func close():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	sfx.play()
	content.hide()
