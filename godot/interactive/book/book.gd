extends Interactive

func _physics_process(_delta: float):
	if Engine.is_editor_hint():
		return
	if is_controlling:
		#player_animations()
		_try_handle_input()

func handle_interaction():
	#处理hud出现的逻辑
	pass
