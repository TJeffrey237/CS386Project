@tool
class_name MainMenuTest
extends GutTest

const MAIN_MENU_SCENE = preload("res://scenes/main_menu.tscn")
const MAIN_MENU_TEST_SCRIPT = preload("res://tests/acceptance/main_menu_testing.gd")
const USER_INTERACTIONS_SCRIPT = preload("res://tests/user_interactions.gd")

var main_menu_scene: Control
var start_button: TextureButton
var exit_button: TextureButton
var user_interactions = USER_INTERACTIONS_SCRIPT.new()

func before_each():
	main_menu_scene = MAIN_MENU_SCENE.instantiate()
	add_child(main_menu_scene)
	await get_tree().process_frame
	start_button = main_menu_scene.get_node("VBoxContainer/Start")
	exit_button = main_menu_scene.get_node("VBoxContainer/Exit")
	assert_not_null(start_button, "Start button should exist.")
	assert_not_null(exit_button, "Exit button should exist.")
	main_menu_scene.set_script(MAIN_MENU_TEST_SCRIPT)
	assert_not_null(main_menu_scene, "Main menu should be instantiated")
	await get_tree().process_frame

func after_each():
	if is_instance_valid(main_menu_scene):
		main_menu_scene.queue_free()
		await get_tree().process_frame
	main_menu_scene = null

func test_start_game():
	assert_not_null(main_menu_scene)
	watch_signals(main_menu_scene)
	assert_has_signal(main_menu_scene, "start_game_requested")
	var start_button = main_menu_scene.get_node("VBoxContainer/Start")
	var vbox = main_menu_scene.get_node("VBoxContainer")
	assert_not_null(start_button)
	
	await get_tree().process_frame

	user_interactions.click((start_button.position + vbox.position), self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert_signal_emitted(main_menu_scene, "start_game_requested")
	
func test_exit_game():
	assert_not_null(main_menu_scene)
	watch_signals(main_menu_scene)
	assert_has_signal(main_menu_scene, "exit_game_requested")
	var exit_button = main_menu_scene.get_node("VBoxContainer/Exit")
	var vbox = main_menu_scene.get_node("VBoxContainer")
	assert_not_null(exit_button)
	
	await get_tree().process_frame
	
	user_interactions.click((exit_button.position + vbox.position), self)
	
	await get_tree().process_frame
	await get_tree().process_frame
	
	assert_signal_emitted(main_menu_scene, "exit_game_requested")
