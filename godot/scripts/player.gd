extends Area2D

# --------- VARIABLES ---------- #

@export_category("Player Properties") # You can tweak these changes according to your likings
@export var move_speed : float = 400

var target_position: Vector2
var is_moving := false
var is_focus := true
var current_interative_area: Interactive

@onready var player_sprite = $AnimatedSprite2D
#@onready var spawn_point = %PlayerSpawner
@onready var particle_trails = $ParticleTrails
@onready var death_particles = $DeathParticles
@onready var camera = $Camera2D

# --------- BUILT-IN FUNCTIONS ---------- #

func _ready():
	target_position = global_position

func _physics_process(_delta: float) -> void:
	# Calling functions
	movement(_delta)
	player_animations()
	flip_player()
	
func _unhandled_input(event: InputEvent) -> void:
	if !is_focus:
		return
	
	if event.is_action_pressed("move"): #TODO:需考虑如何避免和UI冲突
		target_position = get_global_mouse_position()
		is_moving = true
	elif event.is_action_pressed("attach"):
		if current_interative_area:
			is_focus = false
			current_interative_area.attach()
			await possess_tween()
			hide()
			camera.enabled = false
	elif event.is_action_pressed("chat"):
		pass #TODO: 等对话功能完成后补上
# --------- CUSTOM FUNCTIONS ---------- #

# <-- Player Movement Code -->
func movement(delta):
	if is_moving and is_focus:
		var direction = (target_position - global_position).normalized()
		var distance = global_position.distance_to(target_position)
		
		if distance > 1:
			position = position.move_toward(target_position, move_speed * delta)
		else:
			position = target_position
			is_moving = false

# Handle Player Animations
func player_animations():
	particle_trails.emitting = false
	
	if is_moving:
		particle_trails.emitting = true

# Flip player sprite based on X velocity
func flip_player():
	var direction = (target_position - global_position).normalized()
	
	if direction.x < 0: 
		player_sprite.flip_h = true
	elif direction.x > 0:
		player_sprite.flip_h = false

# Tween Animations
func possess_tween():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	#global_position = spawn_point.global_position
	await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()
	respawn_tween()

func respawn_tween():
	var tween = create_tween()
	tween.stop(); tween.play()
	tween.tween_property(self, "scale", Vector2.ONE, 0.15) 
	
# 玩家出生/取消附身
func respawn(pos: Vector2):
	position = pos
	camera.enabled = true
	camera.make_current()
	show()
	await respawn_tween()
	is_focus = true

# --------- SIGNALS ---------- #

# Reset the player's position to the current level spawn point if collided with any trap

#func _on_collision_body_entered(_body):
	#if _body.is_in_group("Traps"):
		#AudioManager.death_sfx.play()
		#death_particles.emitting = true
		#death_tween()


func _on_area_entered(area:Area2D) -> void:
	if area.is_in_group("interact_area"):
		if area.has_method("get_owneer"):
			current_interative_area = area.get_owneer()

func _on_area_exited(area: Area2D) -> void:
	current_interative_area = null
