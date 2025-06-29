@tool
extends Interactive


var current_award: Vector2 = Vector2.RIGHT

## 眼球的特点: 全向移动, 转弯很缓慢
func _movement(_delta: float):
	var vector = Input.get_vector("Left", "Right", "Up", "Down")
	if vector.is_zero_approx():
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
	else:
		current_award = current_award.lerp(vector, 0.2).normalized()
		velocity = velocity.lerp(vector * move_speed, 0.2)
	global_rotation = current_award.angle()
	
	#if current_award.angle() > abs(PI / 2):
		#global_rotation = current_award.angle() + PI
	#else:
		#global_rotation = current_award.angle()

func flip_player():
	pass
