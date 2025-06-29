extends IManager

@export var main_menu_scene: PackedScene

@export var all_hud: Dictionary[StringName, PackedScene]

var current_hud: Dictionary[StringName, IHud] = {}
var current_ui: IUi


func _setup():
	_spawn(main_menu_scene)
	for key in all_hud:
		var hud = all_hud[key].instantiate()
		MEventbus.main.ui_view.add_child(hud)
		current_hud[key] = hud
		current_hud[key].hide()


func _spawn(scene: PackedScene) -> CanvasLayer:
	var canvas = scene.instantiate()
	if canvas is IUi:
		if current_ui:
			current_ui.queue_free()
		current_ui = canvas
		MEventbus.main.game_view.add_child(current_ui)
		return canvas
	else:
		canvas.queue_free()
		return null


func _hide_hud(except_hud_name: Array[StringName]):
	for hud_name in current_hud.keys():
		if except_hud_name.has(hud_name):
			current_hud[hud_name].show()
		else:
			current_hud[hud_name].hide()


func _unspawn():
	current_ui.queue_free()
	current_ui = null


func _all_unspawn():
	for i in MEventbus.main.ui_view.get_children():
		i.queue_free()
