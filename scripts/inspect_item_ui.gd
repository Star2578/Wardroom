extends CanvasLayer

class_name InspectItemUI

@export var MeshInstance: MeshInstance3D
@export var description: RichTextLabel

func _ready():
	GameController.inspect_item_ui = self
	hide()

func set_mesh(_mesh: Mesh):
	MeshInstance.mesh = _mesh

func set_mesh_scale(_scale: Vector3):
	MeshInstance.scale = _scale

func set_description(text: String):
	description.text = text
