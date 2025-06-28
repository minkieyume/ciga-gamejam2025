extends Node

@onready var main_ui: IUi = $MainUI
@onready var fail_ui: IUi = $FailUi
@onready var pause_ui: IUi = $PauseUI
@onready var ballon = $Ballon


func get_ballon():
	return ballon


func _on_fail_ui_back_menu() -> void:
	fail_ui.visible = false
	main_ui.visible = true


func pause() -> void:
	pause_ui.visible = true
