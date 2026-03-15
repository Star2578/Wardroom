extends CanvasLayer


@export var MeshInstance: MeshInstance3D

func _ready():
	hide()

func set_mesh(mesh: Mesh):
	MeshInstance.mesh = mesh