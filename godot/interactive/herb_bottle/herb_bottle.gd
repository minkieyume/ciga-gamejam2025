extends Interactive

class_name HerbBottle

signal herb_added(herb_id)

#不同种类药剂的唯一编号
@export var herb_id:=-1

func _ready() -> void:
	super()
	#.connect("herb_added", Callable(herb_id, "_on_herb_added"))

func _try_handle_input():
	super()
	# 允许跳跃
	if is_controlling:
		handle_jumping()
	# 保留父类的交互逻辑
		# if event.is_action_pressed("interact"):
		# 	handle_interaction() 
			
func _on_SelfArea_body_entered(body):
	if body.is_in_group("Traps") :
		disattach()
		AudioManager.death_sfx.play()
#		death_particles.emitting = true
		death_tween()
	if body.is_in_group("Pot"):
		disattach()
		AudioManager.death_sfx.play()
#		death_particles.emitting = true
		added_into_pot_tween()
		emit_signal("herb_added")
		
#TODO:药水扔到锅里的动画
func added_into_pot_tween():
	death_tween()
