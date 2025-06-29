extends IUi

signal game_start(start_level_scene: PackedScene)


@export var intoduction_ui: PackedScene

@export_subgroup("依赖")
@export var start_game_button: Button
@export var quit_game_button: Button
@onready var main_panel = $MainUI/MainPanel
@onready var team_panel = $MainUI/TeamPanel

func _ready():
	start_game_button.pressed.connect(_on_start_button_down)
	
	game_start.connect(
		func(introduction):
			MUiSpawner._spawn(introduction)
	)


func _on_start_button_down() -> void:
	$MainUI/AudioStreamPlayer.stop()
	visible = false
	game_start.emit(intoduction_ui)


func _on_chiko_pressed() -> void:
	main_panel.visible = false
	team_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_quit_chiko_pressed() -> void:
	team_panel.visible = false
	main_panel.visible = true
