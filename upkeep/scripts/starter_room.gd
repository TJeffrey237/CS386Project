extends Node2D

func _on_window_button_pressed() -> void:
	$InputShield.show()
	var new_scene = preload("res://scenes/tile_puzzle.tscn").instantiate()
	new_scene.connect("exit_pressed", _on_scene1_exit)
	add_child(new_scene)


func _on_vanity_button_pressed() -> void:
	$InputShield.show()
	var new_scene = preload("res://scenes/drawing_puzzle.tscn").instantiate()
	new_scene.connect("exit_pressed", _on_scene2_exit)
	add_child(new_scene)


func _on_floor_button_pressed() -> void:
	$InputShield.show()
	var new_scene = preload("res://scenes/sliding_puzzle.tscn").instantiate()
	new_scene.connect("exit_pressed", _on_scene3_exit)
	add_child(new_scene)
	


func _on_scene1_exit():
	$InputShield.hide()
	$WindowButton.disabled = true


func _on_scene2_exit():
	$InputShield.hide()
	$VanityButton.disabled = true


func _on_scene3_exit():
	$StarterRoom.hide()
	$FloorButton.disabled = true
