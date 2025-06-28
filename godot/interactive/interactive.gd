class_name Interactive
extends CharacterBody2D

# --------- SIGNALS ---------- #
#signal possessed

# --------- VARIABLES ---------- #

@export var player:Node2D
@export var move_speed : float = 300
@export var jump_force : float = 250
@export var gravity : float = 980
@export var max_jump_count : int = 2
var jump_count : int = 2


@export var double_jump : = false

var is_grounded : bool = false

var is_controlling:bool=false
var can_interact: bool = false
var can_possess: bool = false

@onready var player_sprite = $AnimatedSprite2D
#@onready var spawn_point = %SpawnPoint
#待实现：
#@onready var particle_trails = $ParticleTrails
#@onready var death_particles = $DeathParticles
@onready var interact_area = $InteractArea
@onready var camera :Camera2D = $Camera2D

# --------- BUILT-IN FUNCTIONS ---------- #
func _ready():
	$SelfArea.body_entered.connect(_on_SelfArea_body_entered)
	#interact_area.body_entered.connect(_on_IntereactArea_body_entered)
	#interact_area.body_exited.connect(_on_IntereactArea_body_exited)
	#player.connect("possessed", Callable(player, "_on_possessed"))
	print(camera)
	if camera:
		camera.enabled = false
	#test
	#set_control(true)


func _physics_process(_delta: float):
	handle_gravity(_delta)
	# Calling functions
	if is_controlling:
		handle_input()
		movement()
		player_animations()
		flip_player()
	
func handle_input():
	if is_controlling:
		if Input.is_action_just_pressed("interact"):
			print("interact pressed")
			handle_interaction()			
		if Input.is_action_just_pressed("attach"):
			print("disattach pressed")
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
func handle_gravity(delta):
	#初始化时更新is_on_floor
	move_and_slide() 
	# Gravity
	if !is_on_floor():
		velocity.y += gravity*delta
	elif is_on_floor():
		jump_count = max_jump_count

func movement():
	#handle_jumping()
	# Move Player
	var inputAxis = Input.get_axis("Left", "Right")
	#if inputAxis!=0:
		#print("Interactive Moving")
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
	AudioManager.jump_sfx.play()
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
	#print("attached")
	set_control(true)
	if camera:
		camera.enabled = true
		
func disattach():
	print("disattach")
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
		AudioManager.death_sfx.play()
#		death_particles.emitting = true
		death_tween()
		
#func _on_IntereactArea_body_entered(body):
	#if body.is_in_group("Player"):
		#print("player body entered")
		#can_interact = true
		#can_possess = true
#
#func _on_IntereactArea_body_exited(body):
	#if body.is_in_group("Player"):
		#can_interact = false
		#can_possess = false
