extends Control

signal back_menu

func _on_return_button_down() -> void:
	emit_signal("back_menu")
