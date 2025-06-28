@tool
extends Node
enum GameMode {Main_Game, Test_Game}

signal basic_loaded

@export var mode: GameMode :
	set(value):
		mode = value
		notify_property_list_changed()
	get:
		return mode
@export var main_game: PackedScene
@export var test_game: PackedScene


func _ready() -> void:
	if (Engine.is_editor_hint()):
		return
	RenderingServer.set_default_clear_color(Color.BLACK)
	var mainLoop: Node
	match mode:
		GameMode.Main_Game:
			mainLoop = main_game.instantiate()
		GameMode.Test_Game:
			mainLoop = test_game.instantiate()
	add_child(mainLoop)
	MEventbus.main  = mainLoop
	basic_loaded.emit()

func _validate_property(property: Dictionary) -> void:
	
	match mode:
		GameMode.Main_Game:
			if property.name == "test_game":
				property.usage = PROPERTY_USAGE_NO_EDITOR
		GameMode.Test_Game:
			if property.name == "main_game":
				property.usage = PROPERTY_USAGE_NO_EDITOR
