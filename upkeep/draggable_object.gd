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
			if event.pressed:
				print(1)
			if event.button_index == MOUSE_BUTTON_LEFT:
				print(2)
			if is_hovered(mouse_position):
				print(3)
				
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT and is_hovered(mouse_position):
			if DEBUG_MODE:
				print("Request being sent to server to move object ", object_id)
			var response = Server.handle_request("request_move", {"object_id": object_id, "mouse_position": mouse_position})
			if typeof(response) == typeof(""):
				return
			if response.get("approved", false):
				if DEBUG_MODE:
					print("Start holding")
				held = true
				relative_mouse_position = mouse_position - self.position
			
func _process(_delta):
	if held:
		if DEBUG_MODE:
			print("Currently holding")
		if not Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			held = false
			var size = $CollisionShape2D.get_shape().get_rect().size
			Server.handle_request("finalize_move", {"object_id": object_id, 
																   "new_position": self.position, 
																   "width": size.x * self.scale.x / 2, 
																   "height": size.y * self.scale.y / 2})
		else:
			var mouse_position = get_global_mouse_position()
			self.position = mouse_position - relative_mouse_position
