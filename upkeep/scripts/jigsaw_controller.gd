extends Node2D

var pieces = []
var place_locations = []

func _ready() -> void:
	pass
	
func add_piece(piece):
	pieces.append(piece)
	for location in piece.valid_locations:
		place_locations.append(location)
	Server.handle_request("create_place_locations", {"object_id": piece.object_id, 
													 "valid_locations": piece.valid_locations})
	
func check_completion():
	var filled_locations = []
	var piece_positions = []
	for piece in pieces:
		piece_positions.append(piece.position)
	
	for location in piece_positions:
		if location in place_locations:
			filled_locations.append(location)
			
	var completed = Server.handle_request("check_jigsaw_completion", {"filled_locations": filled_locations, 
																	  "place_locations":  place_locations})
	if completed:
		finish_puzzle()
	
	return
	
func finish_puzzle():
	pass
