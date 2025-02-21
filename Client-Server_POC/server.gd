extends	Node

var game_state = {}
var object_z_array = []
var available_actions = {}

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
	object_z_array.append(object)
	print("Object ", object_id, " added")
	return "Object added"

func request_move(data):
	var object_id = data.get("object_id", "")
	print("Object in game state? ", object_id in game_state)
	if object_id in game_state:
		var top_most_object = find_top_object(data)
		if object_id != top_most_object:
			return {"approved": false}
		var temp_object = game_state[object_id]
		object_z_array.erase(temp_object)
		object_z_array.insert(0, temp_object)
		fix_z_order()
		print("Approved.")
		return {"approved": true, "current_position": game_state[object_id].position}
	return {"approved": false}
	
func find_top_object(data):
	var overlapping_objects = []
	for current_object_id in game_state.keys():
		if game_state[current_object_id].get_node("CollisionShape2D").get_shape().get_rect().has_point(game_state[current_object_id].to_local(data["mouse_position"])):
			overlapping_objects.append(current_object_id)
	var top_most_object = null
	for object in object_z_array:
		for overlap_object_id in overlapping_objects:
			if game_state[overlap_object_id] == object:
				top_most_object = overlap_object_id
				break
		if top_most_object != null : break
	return top_most_object
	
func fix_z_order():
	var max_z = object_z_array.size()
	for i in range(max_z):
		object_z_array[i].z_index = max_z - i

func finalize_move(data):
	var object_id = data.get("object_id", "")
	var new_position = data.get("new_position", Vector2.ZERO)
	
	var window_size = Vector2(get_tree().root.size)
	var left_edge = -(window_size.x / 2)
	var right_edge = window_size.x / 2
	var top_edge = window_size.y / 2
	var bottom_edge = -(window_size.y / 2)
	
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
		
	print("New Position Post-Fix: ", new_position)

	game_state[object_id].position = new_position
	return {"Move Confirmed": true, "current_position": game_state[object_id].position}
