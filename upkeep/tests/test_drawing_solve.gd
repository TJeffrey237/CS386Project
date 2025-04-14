@tool
class_name DrawingPuzzleTest
extends GutTest

const PUZZLE_SCENE = preload("res://scenes/drawing_puzzle.tscn")
const STEPS = 20

var drawing_puzzle_scene: Node2D

func before_each():
	drawing_puzzle_scene = PUZZLE_SCENE.instantiate()
	add_child(drawing_puzzle_scene)
	await get_tree().process_frame
	assert_not_null(drawing_puzzle_scene, "Puzzle board should be instantiated")

func after_each():
	if is_instance_valid(drawing_puzzle_scene):
		drawing_puzzle_scene.queue_free()
		await get_tree().process_frame
	drawing_puzzle_scene = null

func test_full_clean():
	if drawing_puzzle_scene == null:
		drawing_puzzle_scene = PUZZLE_SCENE.instantiate()
	var brush_size = drawing_puzzle_scene.RADIUS
	
	await get_tree().process_frame
	
	for i in range(drawing_puzzle_scene.height / (brush_size * 2) + 1):
		var start_position = Vector2(0, (2 * (brush_size * i) - brush_size))
	
		var event_press = InputEventMouseButton.new()
		event_press.button_index = MOUSE_BUTTON_LEFT
		event_press.pressed = true
		event_press.position = start_position
		Input.parse_input_event(event_press)
		await get_tree().process_frame
		
		for step in range(STEPS + 1):
			var step_position = start_position.lerp(start_position + (Vector2(drawing_puzzle_scene.width, 0)), float(step) / STEPS if STEPS > 0 else 1.0)
			get_viewport().warp_mouse(step_position)
			await get_tree().process_frame

		var event_release = InputEventMouseButton.new()
		event_release.button_index = MOUSE_BUTTON_LEFT
		event_release.pressed = false
		event_release.position = start_position + (Vector2(drawing_puzzle_scene.width, 0))
		Input.parse_input_event(event_release)
		await get_tree().process_frame
		
	assert_true(drawing_puzzle_scene.check_win(), "Drawing/Cleaning should be solved after drawing over entire screen")
	assert_eq(drawing_puzzle_scene.total_dirty, drawing_puzzle_scene.clean_count, "The total amount of pixels to be cleaned should be equal to the amount that have been cleaned.")
