extends IUi

signal game_start

@export var start_game_button: Button
@export var quit_game_button: Button
@onready var main_panel = $MainUI/MainPanel
@onready var team_panel = $MainUI/TeamPanel


func _ready():
	start_game_button.pressed.connect(_on_start_button_down)


func _on_start_button_down() -> void:
	visible = false
	game_start.emit()

func _on_chiko_pressed() -> void:
	main_panel.visible = false
	team_panel.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()
