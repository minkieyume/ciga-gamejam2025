extends Interactive

class_name HerbBottle

func _unhandled_input(event):
	# 允许跳跃
	if is_controlling:
		if event.is_action_just_pressed("Jump"):
			if is_on_floor() and !double_jump:
				jump()
			elif double_jump and jump_count > 0:
				jump()
				jump_count -= 1
	# 保留父类的交互逻辑
		if event.is_action_just_pressed("interact"):
			handle_interaction() 
