extends	Node

var game_state = {}
var available_actions = {}

var object_z_map ={}
var highest_Z_index = 0

var DEBUG_MODE = false

func _ready():
	available_actions = {
		"add_object": add_object,
		"request_move": request_move,
		"finalize_move": finalize_move
	}

func handle_request(action, data):
	if action in available_actions:
		return available_actions[action].call(data)
	return "Error: Unknown Action"
	
func add_object(data):
	var object_id = data.get("object_id", "")
	var object = data.get("object", Vector2.ZERO)
	
	if object_id in game_state:
		return "Invalid or duplicate object."
	
	game_state[object_id] = object
	object_z_map[object_id] = 0
	update_z_order(object_id)
	
	if DEBUG_MODE:
		print("Object ", object_id, " added")
	
	return "Object added"

func request_move(data):
	if not data.has("object_id"):
		return "Error: Missing object_id"
	var object_id = data.get("object_id", "")
	
	if DEBUG_MODE:
		print("Object in game state? ", object_id in game_state)
		
	if object_id in game_state:
		var top_most_object = find_top_object(data)
		if object_id != top_most_object:
			return {"approved": false}
		update_z_order(object_id)
		
		if DEBUG_MODE:
			print("Move approved.")
			
		return {"approved": true, "current_position": game_state[object_id].position}
	return {"approved": false}
	
func find_top_object(data):
	var overlapping_objects = []
	for current_object_id in game_state.keys():
		var current_object = game_state[current_object_id]
		var mouse_position = data["mouse_position"]
		if current_object.get_node("CollisionShape2D").get_shape().get_rect().has_point(current_object.to_local(mouse_position)):
			overlapping_objects.append(current_object_id)
	var top_most_object = null
	var current_max_z = -1
	for object in object_z_map.keys():
		for overlap_object_id in overlapping_objects:
			if game_state[overlap_object_id] == game_state[object]:
				if game_state[object].z_index > current_max_z:
					top_most_object = overlap_object_id
					current_max_z = game_state[object].z_index
	return top_most_object
	
func update_z_order(object_id):
	var given_object = game_state[object_id]
	given_object.z_index = highest_Z_index
	object_z_map[object_id] = highest_Z_index
	highest_Z_index += 1
	if highest_Z_index > 1000:
		var min_z_index = min(object_z_map.values())
		highest_Z_index -= min_z_index
		for current_object_id in game_state.keys():
			game_state[current_object_id].z_index -= min_z_index
			object_z_map[object_id] = game_state[current_object_id].z_index

func finalize_move(data):
	var object_id = data.get("object_id", "")
	var new_position = data.get("new_position", Vector2.ZERO)
	
	var window_size = Vector2(get_tree().root.size)
	var left_edge = -(window_size.x / 2)
	var right_edge = window_size.x / 2
	var top_edge = window_size.y / 2
	var bottom_edge = -(window_size.y / 2)
	
	if DEBUG_MODE:
		print("Window Size: ", window_size)
		print("Left Edge: ", left_edge)
		print("Right Edge: ", right_edge)
		print("Top Edge: ", top_edge)
		print("Bottom Edge: ", bottom_edge)
		print("New Position Pre-Fix: ", new_position)

	if new_position.x < left_edge + data["width"]:
		new_position.x = left_edge + data["width"]
	if new_position.x > right_edge - data["width"]:
		new_position.x = right_edge - data["width"]
	if new_position.y < bottom_edge + data["height"]:
		new_position.y = bottom_edge + data["height"]
	if new_position.y > top_edge - data["height"]:
		new_position.y = top_edge - data["height"]
	
	if DEBUG_MODE:
		print("New Position Post-Fix: ", new_position)

	game_state[object_id].position = new_position
	return {"Move Confirmed": true, "current_position": game_state[object_id].position}
