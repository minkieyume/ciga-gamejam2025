extends ControlStrategy

@export var character: CharacterBody2D
@export var move_speed:float = 1000

func _focus_listen(_delta: float):
	var vector: Vector2 = Input.get_vector("Left", "Right", "Up", "Down")
	character.velocity = character.velocity.lerp(move_speed * vector * _delta * 10, 0.2)
	character.move_and_slide()
