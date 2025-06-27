extends Interactive

class_name HerbBottle

signal herb_added

func _ready() -> void:
	super()
	#.connect("herb_added", Callable(, "_on_herb_added"))

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
			
func _on_SelfArea_body_entered(body):
	if body.is_in_group("Traps") :
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		death_tween()
	if body.is_in_group("Pot"):
		AudioManager.death_sfx.play()
		death_particles.emitting = true
		death_tween()
		emit_signal("herb_added")
