extends PlatformInteractive

func _physics_process(delta: float):
	#handle_gravity(_delta)
	# Calling functions
	if is_controlling:
		handle_input()
		#movement()
		player_animations()
		#flip_player()
		
	if enabled:
		platform.move(delta)
