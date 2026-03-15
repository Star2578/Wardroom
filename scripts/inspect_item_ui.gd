extends CanvasLayer


@export var MeshInstance: MeshInstance3D
@export var description: RichTextLabel

func _ready():
	hide()

func set_mesh(_mesh: Mesh):
	MeshInstance.mesh = _mesh

func set_mesh_scale(_scale: Vector3):
	MeshInstance.scale = _scale

func set_description(text: String):
	description.text = text