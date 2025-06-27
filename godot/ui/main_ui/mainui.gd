extends Control

signal game_start

func _on_start_button_down() -> void:
	visible = false
	emit_signal("game_start")

func _on_quit_button_down() -> void:
	get_tree().quit()
