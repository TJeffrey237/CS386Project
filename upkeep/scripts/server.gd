extends	Node2D

var game_state = {}
var available_actions = {}

var object_z_map ={}
var highest_Z_index = 0

var placeable_location_objects = {}

var DEBUG_MODE = true

func _ready():
	available_actions = {
		"add_object": add_object,
		"request_move": request_move,
		"finalize_move": finalize_move,
		"create_place_locations": create_place_locations,
		"check_jigsaw_completion" : check_jigsaw_completion
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
		print("Object ", object_id, " added.")
	
	return "Object added"

func request_move(data):
	if not data.has("object_id"):
		return {"approved": false}
	var object_id = data.get("object_id", "")
	
	if DEBUG_MODE:
		print("Object in game state? ", object_id in game_state)
		
	if object_id in game_state and data["moveable"]:
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
				if game_state[object].z_index > current_max_z and game_state[object].moveable:
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
	var object_id = data["object_id"]
	var given_object = game_state[object_id]
	var new_position = data["new_position"]
	
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
	
	var placed = false
	if data["placeable"]:
		if DEBUG_MODE:
			print("Object is placeable.")
		for location_object in placeable_location_objects.values():
			if location_object.position in given_object.valid_locations:
				var given_collision = given_object.get_child(0)
				var location_collision = location_object.get_child(0)
				if collision_check(given_collision, location_collision):
					placed = true
					if DEBUG_MODE:
						print("Object intersects place location.")
						print("Current object location: ", given_object.position)
						print("Placement location: ", location_object.position)
					given_object.position = location_object.position
					new_position = location_object.position
					if (given_object.get("lock_in_place"))[given_object.valid_locations.find(location_object.position)]:
						given_object.moveable = false
					break
	
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

	game_state[object_id].global_position = new_position
	return {"Move Confirmed": true, "current_position": game_state[object_id].global_position, "placed": placed}
	
func collision_check(collision_shape1, collision_shape2):
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	query.set_shape(collision_shape1.shape)
	query.transform = collision_shape1.global_transform
	query.collision_mask = collision_shape2.get_parent().collision_mask
	var result = space.intersect_shape(query)
	for collision in result:
		if collision["collider"] == collision_shape2.get_parent():
			return true
	return false

func create_place_locations(data):
	if DEBUG_MODE:
		print("Starting to place locations.")
	var given_object_id = data["object_id"]
	var given_object = game_state[given_object_id]
	# NOTE: For now, this will require the collision of the object to be the
	# first child node within the given object's tree, and for the visible part 
	# of it to be the second, which should be easy to enforce, but it simply 
	# has to be kept in mind
	var given_collision_shape = given_object.get_child(0)
	var given_visible_shape = given_object.get_child(1)
	for location in data["valid_locations"]:
		if DEBUG_MODE:
			print("Placing location: ", location)
		var copied_object = given_object.duplicate()
		copied_object.set_script(null)
		copied_object.position = location
		copied_object.rotation = given_object.rotation
		copied_object.scale = given_object.scale
		var copied_collision = given_collision_shape.duplicate()
		copied_object.add_child(copied_collision)
		var copied_visuals = given_visible_shape.duplicate()
		copied_object.add_child(copied_visuals)
		copied_object.modulate.a = 0.2
		placeable_location_objects[copied_object.get_instance_id()] = copied_object
		given_object.get_parent().add_child.call_deferred(copied_object)

func check_jigsaw_completion(data):
	var filled_locations = data["filled_locations"]
	var given_place_locations = data["place_locations"]
	for location in given_place_locations:
		if not location in filled_locations.keys():
			if DEBUG_MODE:
				print("Jigsaw not complete.")
			return false
		else:
			if location not in filled_locations[location].valid_locations:
				if DEBUG_MODE:
					print("Jigsaw not complete. (Location match, but not right piece)")
				return false
	if DEBUG_MODE:
		print("Jigsaw complete.")
	return true
