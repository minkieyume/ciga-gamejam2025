extends Area2D

func _ready() -> void:
	$Sprite2D.play(&"default")

# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if body is Interactive:
		body.position = Vector2(540,180)
		#AudioManager.level_complete_sfx.play()
		#SceneTransition.load_scene(next_scene)
