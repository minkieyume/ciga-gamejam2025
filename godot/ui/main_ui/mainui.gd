extends IUi

signal game_start

@export var start_game_button: Button
@export var quit_game_button: Button


func _ready():
	start_game_button.pressed.connect(_on_start_button_down)
	quit_game_button.pressed.connect(_on_quit_button_down)


func _on_start_button_down() -> void:
	visible = false
	game_start.emit()


func _on_quit_button_down() -> void:
	get_tree().quit()
