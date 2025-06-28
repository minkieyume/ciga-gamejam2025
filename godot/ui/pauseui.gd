extends IUi

signal resume

signal back_menu

@export var resume_button: Button
@export var return_button: Button


func _ready():
	return_button.pressed.connect(_on_return_button_down)
	resume_button.pressed.connect(_on_resume_button_down)


func _on_resume_button_down() -> void:
	visible = false
	emit_signal("resume")


func _on_return_button_down() -> void:
	visible = false
	emit_signal("back_menu")
