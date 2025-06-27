extends Node

@export var main_menu_scene: PackedScene

@export var all_hud: Dictionary[StringName, Canvas] 

var current_hud: Dictionary[StringName, Canvas] = {}
var current_ui: IUi

func _initialize():
	_spawn(main_menu_scene)


func _spawn(scene: PackedScene) -> CanvasLayer:
	var canvas = scene.instantiate()
	if (canvas is IUi):
		current_ui.push_front(canvas)
		return canvas
	elif (canvas is IHud):
		current_hud[canvas.name] = canvas as Canvas
		MEventbus.main.ui_view.add_child(canvas)
		canvas.data_intialize()
		return canvas
	else:
		canvas.queue_free()
		return null

func _unspawn(hud_info: String = ):
	if (hud_info != "" && current_hud.has(hud_info)):
		current_hud[hud_info].queue_free()
		current_hud.erase(hud_info)
	else:
		current_ui.queue_free()
		current_ui = null
	
func _all_unspawn():
	for i in MEventbus.main.ui_view.get_children():
		i.queue_free()
