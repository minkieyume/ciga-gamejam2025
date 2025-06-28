## Interactive: 所有可交互物品的基类
## 

class_name Interactive
extends CharacterBody2D

# --------- SIGNALS ---------- #
#signal possessed

# --------- VARIABLES ---------- #

<<<<<<< HEAD
#@export var player: Node2D FIXME 使用单例代替
@export var move_speed : float = 400 ## 移动的速度
@export var jump_force : float = 600 ## 跳跃的力度
@export var gravity : float = 30 ## 重力

@export var max_jump_count : int = 2 ## 连续跳跃次数
=======
@export var player:Node2D
@export var move_speed : float = 300
@export var jump_force : float = 250
@export var gravity : float = 980
@export var max_jump_count : int = 2
>>>>>>> f8f00de9a69eb8b30dd11d8ce92dfaeb1224ef40
var jump_count : int = 2


@export var double_jump : = false ## 二段跳开关 

var is_grounded : bool = false ## WARNING 判断当前是否在地上？ 

var is_controlling : bool = false ## 判断当前是否被控制
var can_interact : bool = false ## 是否可以交互 
var can_possess : bool = false ## 是否可以附身

@export_subgroup("引用依赖项")
@export var player_sprite : AnimatedSprite2D
#@onready var spawn_point = %SpawnPoint
#待实现：
#@onready var particle_trails = $ParticleTrails
#@onready var death_particles = $DeathParticles
@export var interact_area : Area2D
@export var camera : Camera2D
@export var self_area: Area2D

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready():
	self_area.body_entered.connect(_on_SelfArea_body_entered)
	interact_area.body_entered.connect(_on_IntereactArea_body_entered)
	interact_area.body_exited.connect(_on_IntereactArea_body_exited)
	#player.connect("possessed", Callable(player, "_on_possessed"))
	if camera:
		camera.enabled = false

func _physics_process(delta: float) -> void:
	# Calling functions
	if is_controlling:
		movement(delta)
		player_animations()
		flip_player()
	
func _unhandled_input(event):
	if is_controlling:
		if event.is_action_pressed("interact"):
			handle_interaction()			
		if event.is_action_pressed("attach"):
			disattach()
	#if can_interact and event.is_action_just_pressed("dialog"):
		## 这里实现对话逻辑
		#print("对话触发")
	#if can_possess and event.is_action_just_pressed("interact"):
		##附身
		#set_control(true)
		#emit_signal("possessed")
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement(delta):
	var direction = 0.0
	
	if Input.is_action_pressed("Left"):
		direction -= 1.0
	elif Input.is_action_pressed("Right"):
		direction += 1.0
		
	velocity.x = direction * move_speed
	
	# Gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor():
		jump_count = max_jump_count
	
	move_and_slide()
	#handle_jumping()
	
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	velocity = Vector2(inputAxis * move_speed, velocity.y)
	move_and_slide()

# Handles jumping functionality (double jump or single jump, can be toggled from inspector)
func handle_jumping():
	if Input.is_action_pressed("Jump"):
		if is_on_floor() and !double_jump:
			jump()
		elif double_jump and jump_count > 0:
			jump()
			jump_count -= 1

# Player jump
func jump():
	jump_tween()
	#AudioManager.jump_sfx.play()
	velocity.y = -jump_force

# Handle Player Animations
# 未实现particle_trails
func player_animations():
#	particle_trails.emitting = false
	
	if is_on_floor():
		if abs(velocity.x) > 0:
#			particle_trails.emitting = true
			player_sprite.play("Walk", 1.5)
		else:
			player_sprite.play("Idle")
	else:
		player_sprite.play("Jump")

# Flip player sprite based on X velocity
func flip_player():
	if velocity.x < 0: 
		player_sprite.flip_h = true
	elif velocity.x > 0:
		player_sprite.flip_h = false

# Tween Animations
func death_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	#await tween.finished
	#global_position = spawn_point.global_position
	#await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	#respawn_tween()
#
#func respawn_tween():
	#var tween = create_tween()
	#tween.stop(); tween.play()
	#tween.tween_property(self, "scale", Vector2.ONE, 0.15) 

func jump_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0.7, 1.4), 0.1)
	tween.tween_property(self, "scale", Vector2.ONE, 0.1)


func set_control(state: bool):
	is_controlling = state
	
func handle_interaction():
	#空实现,子类覆写
	pass
	
func attach():
	set_control(true)
	if camera:
		camera.enabled = true
		
func disattach():
	set_control(false)
	if camera:
		camera.enabled = false
	var spawner=get_tree().get_first_node_in_group("player_spawner")
	if spawner:
		spawner.spawn()
	

# --------- SIGNALS ---------- #

# SelfArea内碰到陷阱时触发死亡
# 未实现死亡动画
func _on_SelfArea_body_entered(body):
	if body.is_in_group("Traps") or body.is_in_group("Pot"):
		#AudioManager.death_sfx.play()
#		death_particles.emitting = true
		death_tween()
		
func _on_IntereactArea_body_entered(body):
	if body.is_in_group("Player"):
		can_interact = true
		can_possess = true

func _on_IntereactArea_body_exited(body):
	if body.is_in_group("Player"):
		can_interact = false
		can_possess = false
