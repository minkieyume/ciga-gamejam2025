@tool
extends Area2D

@export var target_position: Vector2
@export var target_id: int:
	set(value):
		target_id = value
			
@export var level: Level


func _ready() -> void:
	$Sprite2D.play(&"default")

# Load next level scene when player collide with level finish door.
func _on_body_entered(body):
	if body is HerbBottle: 
		await level._change_camera_limit(target_id)
		body._fix_camera()
		MPlayerStatic.player_static._fix_camera()
		body.global_position = target_position
		
		#AudioManager.level_complete_sfx.play()
		#SceneTransition.load_scene(next_scene)
