extends Node2D

func _on_texture_button_pressed() -> void:
	var new_scene = preload("res://scenes/tile_puzzle.tscn").instantiate()
	new_scene.connect("exit_pressed", _on_new_scene_exit)
	add_child(new_scene)

func _on_new_scene_exit():
	$WindowButton.disabled = true
