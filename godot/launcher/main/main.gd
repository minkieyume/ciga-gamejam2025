class_name Main
extends Node

@export var game_view: Node

@export var ui_view: Node

## FIXME 功能完善后需要删除
@export var start_level_test: PackedScene ## 测试用场景加载，模块完成

func _ready() -> void:
	load_start_level()

## FIXME 功能完善后需要删除
func load_start_level():
	await MPlayerStatic._setup()
	await MLevel._setup()
	#await MUiSpawner._setup()
	
	MLevel.level_loaded.emit.call_deferred(start_level_test)
