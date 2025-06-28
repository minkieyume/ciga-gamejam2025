extends Node2D
class_name Piston

@export var push_force := 1000.0 ## 推力
var push_direction := Vector2.RIGHT ## 推动方向
var previous_position: Vector2 
var bodies_in_zone: Array[RigidBody2D] = []

func _ready():
	$AnimationPlayer.play("retract")
	$CharacterBody2D/Area2D.connect("body_entered", _on_body_entered)

func _on_body_entered(body: Node):
	if body is RigidBody2D and body not in bodies_in_zone:
		bodies_in_zone.append(body)

func _physics_process(_delta):
	# 更新推力方向
	push_direction = ($CharacterBody2D.position - previous_position).normalized()
	previous_position = $CharacterBody2D.position
	
	# 推动所有区域内刚体
	for body in bodies_in_zone:
		body.apply_impulse(Vector2.ZERO, push_direction * push_force)
	bodies_in_zone.clear()

# 动画结束后重置
func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "extend":
		$AnimationPlayer.play("retract")
	else:
		$Timer.start(1.0)  # 等待1秒后重新推出

func _on_Timer_timeout():
	$AnimationPlayer.play("extend")
