extends Control

signal game_start

func _on_start_button_down() -> void:
	emit_signal("game_start")
