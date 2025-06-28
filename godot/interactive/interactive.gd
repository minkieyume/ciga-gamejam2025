class_name Interactive
extends CharacterBody2D

# --------- SIGNALS ---------- #
#signal possessed

# --------- VARIABLES ---------- #

@export var move_speed: float = 300
@export var jump_force: float = 250
@export var gravity: float = 980 / 2
@export var max_jump_count: int = 2
#@export var dialogue_resource: DialogueResource
@export var dialogue_node: String
var jump_count: int = 2

@export var double_jump := false

var is_controlling: bool = false
var can_interact: bool = false
var can_possess: bool = false
var ignore_attach_input: bool = false
#主要用于控制爬梯子
var can_move_vertical:bool=false

@export var player_sprite: Sprite2D
#@onready var spawn_point = %SpawnPoint
#待实现：
#@onready var particle_trails = $ParticleTrails
#@onready var death_particles = $DeathParticles
@export var interact_area: Area2D
@export var self_area: Area2D
@export var camera: Camera2D


# --------- BUILT-IN FUNCTIONS ---------- #
func _ready():
	if Engine.is_editor_hint():
		return
	self_area.body_entered.connect(_on_SelfArea_body_entered)
	self_area.area_entered.connect(_on_SelfArea_area_entered)
	self_area.area_exited.connect(_on_SelfArea_area_exited)
	#player.connect("possessed", Callable(player, "_on_possessed"))
	if camera:
		camera.enabled = false
	#test
	#set_control(true)


func _physics_process(_delta: float):
	if Engine.is_editor_hint():
		return
	handle_gravity(_delta)
	# Calling functions
	if is_controlling:
		_try_handle_input()
		_movement()
		#player_animations()
		flip_player()


## 可覆盖: 与目标相关的交互逻辑, 相当于控制器
func _try_handle_input():
	if is_controlling and !can_move_vertical:
		#梯子上禁用解除附身操作
		if Input.is_action_just_pressed("interact"):
			#print("interact pressed")
			handle_interaction()
		if Input.is_action_just_pressed("attach") and not ignore_attach_input:
			#print("disattach pressed")
			disattach()
		# 重置输入缓冲
		ignore_attach_input = false
	if can_interact and Input.is_action_just_pressed("dialog"):
		## 这里实现对话逻辑
		var nodes = get_tree().get_nodes_in_group("ui_view")
		if !nodes.is_empty():
			var ballon = nodes[1].get_ballon()
			#ballon.start(dialogue_resource,dialogue_node)
	#if can_possess and event.is_action_just_pressed("interact"):
	##附身
	#set_control(true)
	#emit_signal("possessed")


# --------- CUSTOM FUNCTIONS ---------- #


# <-- Player Movement Code -->
func handle_gravity(delta):
	if can_move_vertical:
		#梯子上不结算重力
		return
	#初始化时更新is_on_floor
	move_and_slide()
	# Gravity
	if !is_on_floor():
		velocity.y += gravity * delta
	elif is_on_floor():
		jump_count = max_jump_count


## 移动逻辑: 每个Interactive都有所不同
func _movement():
	#handle_jumping()
	# Move Player
	var inputHorizontal = Input.get_axis("Left", "Right")
	var inputVertical=Input.get_axis("Up", "Down")
	#if inputAxis!=0:
	#print("Interactive Moving")
	if can_move_vertical:
		velocity = Vector2(inputHorizontal * move_speed, velocity.y+inputVertical*move_speed)
	else:
		velocity = Vector2(inputHorizontal * move_speed, velocity.y)
	move_and_slide()


## 跳跃逻辑
func handle_jumping():
	if can_move_vertical:
		return
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


## WARNING:可复用性较低,应考虑子类实现
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
	print("attached")
	set_control(true)
	if camera:
		camera.enabled = true
	# 设置输入缓冲，避免同一帧内触发disattach
	ignore_attach_input = true
	# 延迟一帧处理输入，避免同一帧内触发disattach
	await get_tree().process_frame


func disattach():
	print("disattach")
	set_control(false)
	if camera:
		camera.enabled = false
	var spawner: PlayerSpawner = get_tree().get_first_node_in_group("player_spawner")
	if spawner:
		spawner.global_position = global_position
		spawner.spawn()


# --------- SIGNALS ---------- #


# SelfArea内碰到陷阱时触发死亡
# 未实现死亡动画
func _on_SelfArea_body_entered(body):
	if body.is_in_group("Traps") or body.is_in_group("Pot"):
		#交互物死亡时,灵魂退出附身比较合理
		disattach()
		AudioManager.death_sfx.play()
#		death_particles.emitting = true
		death_tween()
		
func _on_SelfArea_area_entered(area):
	if area.is_in_group("ladder"):
		can_move_vertical=true
		velocity.y=0
		
func _on_SelfArea_area_exited(area):
	if area.is_in_group("ladder"):
		can_move_vertical=false
