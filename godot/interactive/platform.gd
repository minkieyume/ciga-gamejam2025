extends StaticBody2D

var target_position := Vector2.ZERO
var move_speed := 0.0

signal reached

func setup(target_pos, speed):
	target_position = target_pos
	move_speed = speed

func move(delta):
	var direction = (target_position - position).normalized()
	var distance = position.distance_to(target_position)
	
	if distance > move_speed * delta:
		position = position.move_toward(target_position, move_speed * delta)
	else: 
		position = target_position
		emit_signal("reached")
