extends IUi

signal game_start(start_level_scene: PackedScene)


@export var start_level : PackedScene

@export_subgroup("依赖")
@export var start_game_button: Button
@export var quit_game_button: Button
@onready var main_panel = $MainUI/MainPanel
@onready var team_panel = $MainUI/TeamPanel

func _ready():
	start_game_button.pressed.connect(_on_start_button_down)
	
	game_start.connect(
	func(start_level_scene: PackedScene):
		var current_state = MGameState.state_machine._get_leaf_state()
		if current_state is GameStartState:
			current_state.update_trigger = true
		MLevel.level_loaded.emit(start_level_scene)
	)


func _on_start_button_down() -> void:	
	visible = false
	game_start.emit(start_level)


func _on_chiko_pressed() -> void:
	$MainUI/crazy_music.play()
	main_panel.visible = false
	team_panel.visible = true


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_quit_chiko_pressed() -> void:
	$MainUI/crazy_music.stop()
	team_panel.visible = false
	main_panel.visible = true
