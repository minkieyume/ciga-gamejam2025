extends Control

signal resume

signal back_menu

func _on_resume_button_down() -> void:
	visible = false
	emit_signal("resume")

func _on_return_button_down() -> void:
	visible = false
	emit_signal("back_menu")
