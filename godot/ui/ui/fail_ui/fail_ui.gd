extends IUi

signal back_menu

@export var back_menu_button: Button


func _ready():
	back_menu_button.pressed.connect(_on_return_button_down)


func _on_return_button_down() -> void:
	emit_signal("back_menu")
