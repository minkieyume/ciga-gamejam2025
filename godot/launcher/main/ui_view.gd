extends Node

@onready var main_ui = $MainUI
@onready var fail_ui = $FailUi
@onready var ballon = $Ballon

func get_ballon():
	return ballon

func _on_fail_ui_back_menu() -> void:
	fail_ui.visible = false
	main_ui.visible = true
