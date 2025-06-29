extends Area2D

# --------- VARIABLES ---------- #

@export_category("Player Properties")  # You can tweak these changes according to your likings
@export var move_speed: float = 400

var target_position: Vector2
var is_moving := false
var is_focus := true
var current_interactive_area: Interactive
#用数组维护进入的区域对象
var entered_areas: Array[Interactive] = []

@export var player_sprite: AnimatedSprite2D

@export var particle_trails: CPUParticles2D
@export var death_particles: CPUParticles2D
@export var camera: Camera2D

var input_lock: bool = false
# --------- BUILT-IN FUNCTIONS ---------- #


func _ready():
	target_position = global_position
	_fix_camera()

func _fix_camera():
	camera.limit_left = MEventbus.limit_cameraLU.x
	camera.limit_top = MEventbus.limit_cameraLU.y
	camera.limit_right = MEventbus.limit_cameraRD.x
	camera.limit_bottom = MEventbus.limit_cameraRD.y

func _physics_process(_delta: float) -> void:
	# Calling functions
	_movement(_delta)
	player_animations()
	flip_player()


func _input(event):
	if !is_focus:
		return
	elif event.is_action_pressed("move"):  #TODO:需考虑如何避免和UI冲突
		target_position = get_global_mouse_position()
		is_moving = true
	elif event.is_action_pressed("attach"):
		if current_interactive_area:
			is_focus = false
			var temp = current_interactive_area
			await possess_tween(temp)
			camera.enabled = false
			temp.attach()
			hide.call_deferred()
	elif event.is_action_pressed("chat"):
		pass  #TODO: 等对话功能完成后补上


# --------- CUSTOM FUNCTIONS ---------- #


# <-- Player Movement Code -->
func _movement(delta):
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
		player_sprite.flip_h = false
	elif direction.x > 0:
		player_sprite.flip_h = true


# Tween Animations
## 目前问题
func possess_tween(target: Node2D):
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.15)
	await tween.finished
	await get_tree().create_timer(0.3).timeout
	#AudioManager.respawn_sfx.play()

	# respawn_tween()


func respawn_tween():
	var tween = create_tween()
	tween.stop()
	tween.play()
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


func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("interact_area") and area.has_method("get_owneer"):
		var current_entered_area = area.get_owneer()
		if entered_areas.find(current_entered_area) == -1:
			entered_areas.append(current_entered_area)
			current_interactive_area = current_entered_area


func _on_area_exited(area: Area2D) -> void:
	if area.is_in_group("interact_area") and area.has_method("get_owneer"):
		var current_exited_area = area.get_owneer()
		var leave_area_index: int = entered_areas.find(current_exited_area)
		if leave_area_index != -1:  # 确保找到才移除
			entered_areas.remove_at(leave_area_index)
			current_interactive_area = entered_areas.back() if entered_areas.size() > 0 else null
		if entered_areas.size() != 0:
			current_interactive_area = entered_areas.back()
		else:
			current_interactive_area = null
