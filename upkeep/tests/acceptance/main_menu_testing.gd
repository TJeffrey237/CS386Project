extends "res://scripts/main_menu.gd"

signal start_game_requested
signal exit_game_requested

func _on_start_pressed() -> void:
	emit_signal("start_game_requested")

func _on_exit_pressed() -> void:
	emit_signal("exit_game_requested")
