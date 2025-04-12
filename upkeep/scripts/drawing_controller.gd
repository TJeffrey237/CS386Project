extends Node2D

const RADIUS = 20
const STEP_DISTANCE = 3
const MAX_STEPS = 20
var viewport
var width
var height
var drawing_mask
var mask_texture
#var sprite
var last_mouse_position = null
var DirtyObject

func _ready():
	viewport = get_viewport()
	height = viewport.size.y
	width = viewport.size.x
	drawing_mask = Server.handle_request("create_mask", {"height": height, 
														"width": width, 
														"fill_color": Color(255, 255, 255)})
	mask_texture = ImageTexture.create_from_image(drawing_mask)
	#sprite = Sprite2D.new()
	#sprite.texture = mask_texture
	#sprite.position = Vector2.ZERO
	#sprite.visible = true
	#add_child(sprite)
	DirtyObject = get_node("DirtyObject")
	var shader_material = DirtyObject.material
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	shader_material.set_shader_parameter("viewport_size", Vector2(width, height))

func _process(_delta):
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_position = get_global_mouse_position()
		if last_mouse_position == null:
			last_mouse_position = mouse_position
		draw_around_point(mouse_position, drawing_mask)
		var steps = floor(last_mouse_position.distance_to(mouse_position) / STEP_DISTANCE)
		steps = steps if steps < MAX_STEPS else MAX_STEPS
		print(steps)
		for step in range(steps):
			var step_position = last_mouse_position.lerp(mouse_position, float(step) / steps if steps > 0 else 1.0)
			draw_around_point(step_position, drawing_mask)
		mask_texture.update(drawing_mask)
		last_mouse_position = mouse_position
	else:
		last_mouse_position = null
	if point_off_canvas(get_global_mouse_position()):
		last_mouse_position = null
	check_win()

func draw_around_point(point, image):
	for i in range(-RADIUS, RADIUS):
		for j in range(-RADIUS, RADIUS):
			var x = point.x + i
			var y = point.y + j
			if Vector2(x, y).distance_to(point) < RADIUS and not point_off_canvas(Vector2(x, y)):
				image.set_pixel(x + width / 2, y + height / 2, Color(0, 0, 0))
				
func point_off_canvas(point):
	return point.x > width / 2 - 1 or point.x < -width / 2 or point.y < -height / 2 or point.y > height / 2 - 1
	
func check_win():
	pass
