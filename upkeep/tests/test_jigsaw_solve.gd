@tool
class_name PuzzlePieceTest
extends GutTest
const PUZZLE_SCENE = preload("res://scenes/tile_puzzle.tscn")

var puzzle_board: Node2D

func before_each():
	puzzle_board = PUZZLE_SCENE.instantiate()
	add_child(puzzle_board)
	await get_tree().process_frame
	assert_not_null(puzzle_board, "Puzzle board should be instantiated")

func after_each():
	if is_instance_valid(puzzle_board):
		puzzle_board.queue_free()
		await get_tree().process_frame
	puzzle_board = null

func test_move_puzzle_piece():
	if puzzle_board == null:
		puzzle_board = PUZZLE_SCENE.instantiate()
	var pieces = puzzle_board.pieces

	assert_gt(pieces.size(), 0, "Puzzle board should have at least one piece")

	var piece = pieces[0]
	assert_not_null(piece, "First piece should not be null")
	assert_true(piece is Node2D, "Piece should be a Node2D")

	if piece.valid_locations.size() == 0:
		push_warning("Piece has no valid locations to test movement")
		return

	var target_pos = piece.valid_locations[0]
	assert_ne(piece.position, target_pos, "Piece should start at a different position than the target")

	var event_press = InputEventMouseButton.new()
	event_press.button_index = MOUSE_BUTTON_LEFT
	event_press.pressed = true
	event_press.position = piece.global_position + (Vector2(get_tree().root.size) / 2)
	Input.parse_input_event(event_press)
	await get_tree().process_frame

	get_viewport().warp_mouse(target_pos + (Vector2(get_tree().root.size) / 2))
	await get_tree().process_frame

	var event_release = InputEventMouseButton.new()
	event_release.button_index = MOUSE_BUTTON_LEFT
	event_release.pressed = false
	event_release.position = target_pos + (Vector2(get_tree().root.size) / 2)
	print("EVENT RELEASE POSITION: ", event_release.position)
	Input.parse_input_event(event_release)
	await get_tree().process_frame
	
	print("POSITIONS:", piece.global_position, target_pos)
	assert_eq(piece.position, target_pos, "Piece should be at target position after movement")

func test_all_move_puzzle_piece():
	if puzzle_board == null:
		puzzle_board = PUZZLE_SCENE.instantiate()
	var pieces = puzzle_board.pieces

	assert_gt(pieces.size(), 0, "Puzzle board should have at least one piece")

	for piece in pieces:
		assert_not_null(piece, "First piece should not be null")
		assert_true(piece is Node2D, "Piece should be a Node2D")

		if piece.valid_locations.size() == 0:
			push_warning("Piece has no valid locations to test movement")
			return

		var target_pos = piece.valid_locations[0]
		assert_ne(piece.position, target_pos, "Piece should start at a different position than the target")

		var event_press = InputEventMouseButton.new()
		event_press.button_index = MOUSE_BUTTON_LEFT
		event_press.pressed = true
		event_press.position = piece.global_position + (Vector2(get_tree().root.size) / 2)
		Input.parse_input_event(event_press)
		await get_tree().process_frame

		get_viewport().warp_mouse(target_pos + (Vector2(get_tree().root.size) / 2))
		await get_tree().process_frame

		var event_release = InputEventMouseButton.new()
		event_release.button_index = MOUSE_BUTTON_LEFT
		event_release.pressed = false
		event_release.position = target_pos + (Vector2(get_tree().root.size) / 2)
		print("EVENT RELEASE POSITION: ", event_release.position)
		Input.parse_input_event(event_release)
		await get_tree().process_frame
		
		print("POSITIONS:", piece.global_position, target_pos)
		assert_eq(piece.global_position, target_pos, "Piece should be at target position after movement")

func test_puzzle_board_loads():
	assert_not_null(puzzle_board, "Puzzle board should be loaded")
	var pieces = puzzle_board.pieces
	assert_gt(pieces.size(), 0, "Puzzle board should contain pieces")

func test_piece_has_valid_location():
	var pieces = puzzle_board.pieces
	if pieces.size() > 0:
		var piece = pieces[0]
		if piece is Node2D:
			assert_gt(piece.valid_locations.size(), 0, "Piece should have at least one valid location")
		else:
			push_warning("First piece is not a Node2D")
	else:
		push_warning("Puzzle board has no pieces")
