extends Interactive
class_name PlatformInteractive

@export var platform_move_direction := Vector2.UP
@export var platform_move_distance := 0
@export var platform_move_speed := 0.0

var destination := Vector2.ZERO
var enabled := false
var platform_ori_pos : Vector2

@onready var platform = $Platform

func _ready() -> void:
	super()
	platform_ori_pos = platform.position

func _physics_process(delta: float) -> void:
	super(delta)
	
	if enabled:
		platform.move(delta)

func handle_interaction():
	start()

func start():
	var target_pos = platform.position + (platform_move_direction * platform_move_distance)
	platform.setup(target_pos, platform_move_speed)
	enabled = true
	
func stop():
	enabled = false
	
func player_animations():
	pass

func _on_platform_reached() -> void:
	stop()
