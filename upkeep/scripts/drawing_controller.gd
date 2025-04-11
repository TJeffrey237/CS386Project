extends Node2D

var drawing_mask

func _ready():
	var viewport = get_viewport()
	var width = viewport.size.y
	var height = viewport.size.x
	drawing_mask = Server.handle_request("create_mask", {"height": width, 
														"width": height, 
														"fill_color": Color(0, 0, 0)})
	var mask_texture = ImageTexture.create_from_image(drawing_mask)
	var sprite = Sprite2D.new()
	sprite.texture = mask_texture
	sprite.position = Vector2.ZERO + Vector2(height / 2, width / 2)
	sprite.visible = true
	add_child(sprite)
