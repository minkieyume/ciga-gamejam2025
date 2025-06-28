extends Interactive


func _movement():
	var vector = Input.get_vector("Left", "Right", "Up", "Down")
	#if inputAxis!=0:
	#print("Interactive Moving")
	if vector.is_zero_approx():
		velocity = velocity.lerp(Vector2.ZERO, 0.2)
	else:
		velocity = velocity.lerp(vector * move_speed, 0.2)
	move_and_collide(velocity, true, 0.08, true)
