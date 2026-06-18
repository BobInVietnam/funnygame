extends TextureRect

@export var ui_images: Array[Texture2D]

func switch_to_image(index: int) -> void:
	# Safety check: ensure the index exists in our array list
	if index >= 0 and index < ui_images.size():
		texture = ui_images[index]
