extends Node2D

const RADIUS = 40
const STEP_DISTANCE = 1
const MAX_STEPS = 20
const CLEAN_THRESHOLD = 0.98
var DEBUG_MODE = Server.DEBUG_MODE

var viewport: Viewport
var width: int
var height: int
var mask_image: Image
var mask_texture: ImageTexture
var solve_image: Image
var clean_count: int
var total_dirty: int
var last_mouse_position = null
var DirtyObject: Object
var timer: Timer

var rd: RenderingDevice
var shader: RID
var pipeline: RID
var storage_buffer: RID
var uniform_set: RID
var output_texture: RID
var mask_uniform_set: RID
var solve_uniform_set: RID
var count_set: RID
var count_storage_buffer: RID

func _ready():
	clean_count = 0
	total_dirty = 0
	viewport = get_viewport()
	timer = Timer.new()
	timer.wait_time = 0.1
	add_child(timer)
	timer.start()
	height = viewport.size.y
	width = viewport.size.x
	mask_image = Server.handle_request("create_mask", {"height": height, 
														"width": width, 
														"fill_color": Color(100, 84, 57)})
	mask_texture = ImageTexture.create_from_image(mask_image)
	
	var mask_sprite = Sprite2D.new()
	mask_sprite.texture = mask_texture
	mask_sprite.position = Vector2(width/2.0,height/2.0)
	mask_sprite.visible = true
	DirtyObject = get_node("DirtyObject")
	var object_copy = DirtyObject.duplicate()
	object_copy.position = DirtyObject.position + Vector2(width/2.0,height/2.0)
	object_copy.modulate = Color(0, 0, 0)
	
	var subviewport = SubViewport.new()
	subviewport.size = Vector2(width, height)
	print(subviewport.size)
	subviewport.add_child(mask_sprite)
	subviewport.add_child(object_copy)
	subviewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	
	add_child(subviewport)
	
	await RenderingServer.frame_post_draw
	
	var subviewport_texture = subviewport.get_texture()
	solve_image = subviewport_texture.get_image()
	solve_image.convert(Image.FORMAT_RGBA8)
	
	for x in solve_image.get_width():
		for y in solve_image.get_height():
			if solve_image.get_pixel(x,y) == Color(0, 0, 0):
				total_dirty += 1
	
	mask_sprite.queue_free()
	object_copy.queue_free()
	subviewport.queue_free()
	
	var shader_material = DirtyObject.material
	shader_material.set_shader_parameter("mask_texture", mask_texture)
	shader_material.set_shader_parameter("viewport_size", Vector2(width, height))
	
	setup_compute_shader()

func setup_compute_shader():
	rd = RenderingServer.create_local_rendering_device()
	var shader_file = load("res://scripts/draw.glsl")
	var shader_spirv = shader_file.get_spirv()
	shader = rd.shader_create_from_spirv(shader_spirv)
	pipeline = rd.compute_pipeline_create(shader)
	
	var pba = PackedFloat32Array([]).to_byte_array()
	storage_buffer = rd.storage_buffer_create(((3 + MAX_STEPS) * 2) * 4, pba)

	var uniform_buffer = RDUniform.new()
	uniform_buffer.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	uniform_buffer.binding = 0
	uniform_buffer.add_id(storage_buffer)
	
	var packed_count_array = PackedInt32Array([clean_count]).to_byte_array()
	count_storage_buffer = rd.storage_buffer_create(4, packed_count_array)
	var count_buffer = RDUniform.new()
	count_buffer.uniform_type = RenderingDevice.UNIFORM_TYPE_STORAGE_BUFFER
	count_buffer.binding = 1
	count_buffer.add_id(count_storage_buffer)
	uniform_set = rd.uniform_set_create([uniform_buffer, count_buffer], shader, 0)

	var fmt = RDTextureFormat.new()
	fmt.width = width
	fmt.height = height
	fmt.usage_bits = RenderingDevice.TEXTURE_USAGE_STORAGE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_UPDATE_BIT | RenderingDevice.TEXTURE_USAGE_CAN_COPY_FROM_BIT | RenderingDevice.TEXTURE_USAGE_SAMPLING_BIT
	fmt.format = RenderingDevice.DATA_FORMAT_R8G8B8A8_UNORM
	output_texture = rd.texture_create(fmt, RDTextureView.new(), [mask_image.get_data()])
	var solve_texture = rd.texture_create(fmt, RDTextureView.new(), [solve_image.get_data()])

	var mask_uniform = RDUniform.new()
	mask_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	mask_uniform.binding = 0
	mask_uniform.add_id(output_texture)
	mask_uniform_set = rd.uniform_set_create([mask_uniform], shader, 1)
	
	var solve_uniform = RDUniform.new()
	solve_uniform.uniform_type = RenderingDevice.UNIFORM_TYPE_IMAGE
	solve_uniform.binding = 0
	solve_uniform.add_id(solve_texture)
	solve_uniform_set = rd.uniform_set_create([solve_uniform], shader, 2)

func _process(_delta):
	if timer.time_left <= 0.01:
		#print(Engine.get_frames_per_second())
		#print(clean_count)
		timer.start()
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		var point_array = []
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
		if check_win():
			finish_puzzle()
	else:
		last_mouse_position = null
	if point_off_canvas(get_global_mouse_position()):
		last_mouse_position = null

func draw_around_points(point_array, image):
	var x_offset = width / 2.0
	var y_offset = height / 2.0
	
	var unpacked_points = []
	unpacked_points.append(RADIUS)
	unpacked_points.append(float(point_array.size()))
	for point in point_array:
		unpacked_points.append(point.x + x_offset)
		unpacked_points.append(point.y + y_offset)
	
	var pba = PackedFloat32Array(unpacked_points).to_byte_array()
	rd.buffer_update(storage_buffer, 0, pba.size(), pba)
	var packed_count_array = PackedInt32Array([0]).to_byte_array()
	rd.buffer_update(count_storage_buffer, 0, 4, packed_count_array)

	var compute_list = rd.compute_list_begin()
	rd.compute_list_bind_compute_pipeline(compute_list, pipeline)
	rd.compute_list_bind_uniform_set(compute_list, solve_uniform_set, 2)
	rd.compute_list_bind_uniform_set(compute_list, mask_uniform_set, 1)
	rd.compute_list_bind_uniform_set(compute_list, uniform_set, 0)
	rd.compute_list_dispatch(compute_list, ceil(width / 8.0), ceil(height / 8.0), 1)
	rd.compute_list_end()
	rd.submit()
	rd.sync()

	var updated_image_data = rd.texture_get_data(output_texture, 0)
	var updated_clean_count = rd.buffer_get_data(count_storage_buffer, 0, 4)
	clean_count = updated_clean_count.decode_s32(0)
	image.set_data(width, height, false, Image.FORMAT_RGBA8, updated_image_data)
				
func point_off_canvas(point):
	return point.x > width / 2.0 - 1 or point.x < -width / 2.0 or point.y < -height / 2.0 or point.y > height / 2.0 - 1
	
func check_win():
	return clean_count > total_dirty * CLEAN_THRESHOLD
	
func finish_puzzle():
	var complete_label = get_node("Complete")
	var exit_button = get_node("Exit")
	complete_label.visible = true
	exit_button.visible = true
	
func _on_exit_button_pressed():
	if DEBUG_MODE:
		print("Exit signal received.")
	var exit_button = get_node("Exit")
	if exit_button.visible:
		get_tree().change_scene_to_file("res://scenes/starter_room.tscn")
	
func _exit_tree():
	if rd:
		if shader.is_valid():
			rd.free_rid(shader)
		if storage_buffer.is_valid():
			rd.free_rid(storage_buffer)
		if output_texture.is_valid():
			rd.free_rid(output_texture)
