extends Control

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/starter_room.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
