extends Node2D

var pieces = []
var place_locations = []
var DEBUG_MODE = Server.DEBUG_MODE

func _ready() -> void:
	pass
	
func add_piece(piece):
	pieces.append(piece)
	for location in piece.valid_locations:
		place_locations.append(location)
	Server.handle_request("create_place_locations", {"object_id": piece.object_id, 
													 "valid_locations": piece.valid_locations})
	
func check_completion():
	var filled_locations = {}
	var piece_positions = {}
	for piece in pieces:
		piece_positions[piece.position] = piece
	
	for location in piece_positions.keys():
		if location in place_locations:
			filled_locations[location] = piece_positions[location]
			
	var completed = Server.handle_request("check_jigsaw_completion", {"filled_locations": filled_locations, 
																	  "place_locations":  place_locations})
	if completed:
		finish_puzzle()
		return true
	
	return false
	
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
