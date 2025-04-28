@tool
class_name StarterRoomTest
extends GutTest

const STARTER_ROOM_SCENE = preload("res://scenes/starter_room.tscn")
const USER_INTERACTIONS_SCRIPT = preload("res://tests/user_interactions.gd")

var starter_room_scene: Node2D
var floor_button: TextureButton
var vanity_button: TextureButton
var window_button: TextureButton
var user_interactions = USER_INTERACTIONS_SCRIPT.new()

func before_each():
	starter_room_scene = STARTER_ROOM_SCENE.instantiate()
	add_child(starter_room_scene)
	await get_tree().process_frame
	floor_button = starter_room_scene.get_node("FloorButton")
	vanity_button = starter_room_scene.get_node("VanityButton")
	window_button = starter_room_scene.get_node("WindowButton")
	assert_not_null(floor_button, "FloorButton should exist.")
	assert_not_null(vanity_button, "VanityButton should exist.")
	assert_not_null(window_button, "Window should exist.")
	assert_not_null(starter_room_scene, "Main menu should be instantiated")
	await get_tree().process_frame

func after_each():
	if is_instance_valid(starter_room_scene):
		starter_room_scene.queue_free()
		await get_tree().process_frame
	starter_room_scene = null

func test_floor_puzzle_start():
	assert_not_null(starter_room_scene)
	watch_signals(floor_button)
	floor_button = starter_room_scene.get_node("FloorButton")
	assert_not_null(floor_button)
	
	await get_tree().process_frame

	user_interactions.click(floor_button.position, self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert_signal_emitted(floor_button, "pressed")
	
func test_vanity_puzzle_start():
	assert_not_null(starter_room_scene)
	watch_signals(vanity_button)
	vanity_button = starter_room_scene.get_node("VanityButton")
	assert_not_null(vanity_button)
	
	await get_tree().process_frame
	
	user_interactions.click(vanity_button.position, self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert_signal_emitted(vanity_button, "pressed")

func test_window_puzzle_start():
	assert_not_null(starter_room_scene)
	watch_signals(window_button)
	window_button = starter_room_scene.get_node("WindowButton")
	assert_not_null(window_button)
	
	await get_tree().process_frame
	
	user_interactions.click(window_button.position, self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert_signal_emitted(window_button, "pressed")
