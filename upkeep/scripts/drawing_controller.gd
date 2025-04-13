extends Node2D

const RADIUS = 20
const STEP_DISTANCE = 1
const MAX_STEPS = 10

var viewport
var width
var height
var mask_image: Image
var mask_texture: ImageTexture
#var sprite
var last_mouse_position = null
var DirtyObject
var timer: Timer

var rd
var shader
var pipeline
var storage_buffer
var uniform_set
var output_texture
var texture_uniform_set

func _ready():
	viewport = get_viewport()
	timer = Timer.new()
	timer.wait_time = 0.1
	add_child(timer)
	timer.start()
	height = viewport.size.y
	width = viewport.size.x
	mask_image = Server.handle_request("create_mask", {"height": height, 
														"width": width, 
														"fill_color": Color(255, 255, 255)})
	mask_texture = ImageTexture.create_from_image(mask_image)
	#sprite = Sprite2D.new()
	#sprite.texture = mask_texture
	#sprite.position = Vector2.ZERO
	#sprite.visible = true
	#add_child(sprite)
	DirtyObject = get_node("DirtyObject")
	var shader_material = DirtyObject.material
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	shader_material.set_shader_parameter("viewport_size", Vector2(width, height))
	rd = RenderingServer.create_local_rendering_device()
	var shader_file = load("res://scripts/draw.glsl")
	var shader_spirv = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)
	
	var pba = PackedFloat32Array([]).to_byte_array()
	storage_buffer = rd.storage_buffer_create((4 + MAX_STEPS * 2) * 4, pba)

	var uniform_buffer = RDUniform.new()
	uniform_buffer.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer.binding = 0
	uniform_buffer.add_id(storage_buffer)
	uniform_set = rd.uniform_set_create([uniform_buffer], shader, 0)

	var fmt = RDTextureFormat.new()
	fmt.width = width
	fmt.height = height
	fmt.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	fmt.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	output_texture = rd.texture_create(fmt, RDTextureView.new(), [mask_image.get_data()])

	var texture_uniform = RDUniform.new()
	texture_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	texture_uniform.binding = 0
	texture_uniform.add_id(output_texture)
	texture_uniform_set = rd.uniform_set_create([texture_uniform], shader, 1)

func _process(_delta):
	if timer.time_left <= 0.01:
		print(Engine.get_frames_per_second())
		timer.start()
	var point_array = []
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var mouse_position = get_global_mouse_position()
		if last_mouse_position == null:
			last_mouse_position = mouse_position
		point_array.append(mouse_position)
		var steps = floor(last_mouse_position.distance_to(mouse_position) / STEP_DISTANCE)
		if steps > MAX_STEPS:
			steps = MAX_STEPS
		for step in range(steps):
			var step_position = last_mouse_position.lerp(mouse_position, float(step) / steps if steps > 0 else 1.0)
			point_array.append(step_position)
		draw_around_points(point_array, mask_image)
		mask_texture.update(mask_image)
		last_mouse_position = mouse_position
	else:
		last_mouse_position = null
	if point_off_canvas(get_global_mouse_position()):
		last_mouse_position = null
	check_win()

func draw_around_points(point_array, image):
	var x_offset = width / 2
	var y_offset = height / 2
	
	var unpacked_points = []
	unpacked_points.append(RADIUS)
	unpacked_points.append(float(point_array.size()))
	for point in point_array:
		unpacked_points.append(point.x + x_offset)
		unpacked_points.append(point.y + y_offset)
	
	var pba = PackedFloat32Array(unpacked_points).to_byte_array()
	rd.buffer_update(storage_buffer, 0, pba.size(), pba)

	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, texture_uniform_set, 1)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, ceil(width / 8.0), ceil(height / 8.0), 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()

	var updated_image_data = rd.texture_get_data(output_texture, 0)
	image.set_data(width, height, false, Image.FORMAT_RGBA8, updated_image_data)
				
func point_off_canvas(point):
	return point.x > width / 2 - 1 or point.x < -width / 2 or point.y < -height / 2 or point.y > height / 2 - 1
	
func check_win():
	pass
	
func _exit_tree():
	if rd:
		rd.free_rid(shader)
		rd.free_rid(pipeline)
		rd.free_rid(storage_buffer)
		rd.free_rid(uniform_set)
		rd.free_rid(output_texture)
		rd.free_rid(texture_uniform_set)
		rd.free_rid(rd)
