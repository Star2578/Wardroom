extends Node3D

func _ready():
	generate_icon()

func generate_icon():
	# Await the frame post-draw to ensure the viewport has rendered
	await RenderingServer.frame_post_draw 

	var viewport = $SubViewportContainer/SubViewport
	var viewport_texture = viewport.get_texture()
	var image: Image = viewport_texture.get_image()

	var icon_name = "icon.png"

	# Save the image as a PNG file
	var save_path = "res://scenes/interactable_objects/data/icons/" + icon_name
	image.save_png(save_path)

	print("Icon saved to: ", save_path)
