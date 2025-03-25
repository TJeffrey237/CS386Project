extends "object.gd"

var held = false
var relative_mouse_position = Vector2()

func is_hovered(mouse_pos):
	#print(mouse_pos)
	#print($CollisionShape2D.get_shape())
	#print($CollisionShape2D.get_shape().get_rect())
	return $CollisionShape2D.get_shape().get_rect().has_point(to_local(mouse_pos))

func _input(event):
	if event is InputEventMouseButton and not held:
		var mouse_position = event.global_position - (Vector2(get_tree().root.size) / 2)
		if DEBUG_MODE:
			print(mouse_position)
			print(self.position)
			if event.pressed:
				print("Mouse button is pressed.")
			if event.button_index == MOUSE_BUTTON_LEFT:
				print("Pressed mouse button is left click.")
			if is_hovered(mouse_position):
				print("Mouse is hovering object.")
				
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_hovered(mouse_position):
			if DEBUG_MODE:
				print("Request being sent to server to move object ", object_id)
			var response = Server.handle_request("request_move", {"object_id": object_id, 
																  "mouse_position": mouse_position, 
																  "moveable": moveable})
			if typeof(response) == typeof(""):
				return
			if response.get("approved", false):
				if DEBUG_MODE:
					print("Starting to hold object.")
				held = true
				relative_mouse_position = mouse_position - self.position
			
func _process(_delta):
	var response = false
	if held:
		if DEBUG_MODE:
			print("Currently holding object.")
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			held = false
			var size = $CollisionShape2D.get_shape().get_rect().size
			response = Server.handle_request("finalize_move", {"object_id": object_id, 
													"new_position": self.position, 
													"width": size.x * self.scale.x / 2, 
													"height": size.y * self.scale.y / 2,
													"placeable": placeable})
		else:
			var mouse_position = get_global_mouse_position()
			self.position = mouse_position - relative_mouse_position
			
	return response
