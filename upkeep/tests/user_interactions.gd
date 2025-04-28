extends Node2D

func click_and_drag(starting_location, target_location, object):
	print("started")
	var event_press = InputEventMouseButton.new()
	event_press.button_index = MOUSE_BUTTON_LEFT
	event_press.pressed = true
	event_press.position = starting_location + (Vector2(object.get_tree().root.size) / 2)
	print("EVENT PRESS POSITION: ", event_press.global_position)
	Input.parse_input_event(event_press)
	await object.get_tree().process_frame

	object.get_viewport().warp_mouse(target_location + (Vector2(object.get_tree().root.size) / 2))
	print("still alive")
	await object.get_tree().process_frame

	var event_release = InputEventMouseButton.new()
	event_release.button_index = MOUSE_BUTTON_LEFT
	event_release.pressed = false
	event_release.position = target_location + (Vector2(object.get_tree().root.size) / 2)
	print("EVENT RELEASE POSITION: ", event_release.global_position)
	Input.parse_input_event(event_release)
	await object.get_tree().process_frame
	
	return

func click(location, object):
	var event_press = InputEventMouseButton.new()
	event_press.button_index = MOUSE_BUTTON_LEFT
	event_press.pressed = true
	event_press.position = location
	print("EVENT PRESS POSITION: ", event_press.position)
	Input.parse_input_event(event_press)
	await object.get_tree().process_frame

	var event_release = InputEventMouseButton.new()
	event_release.button_index = MOUSE_BUTTON_LEFT
	event_release.pressed = false
	event_release.position = location
	print("EVENT RELEASE POSITION: ", event_release.position)
	Input.parse_input_event(event_release)
	
	return
