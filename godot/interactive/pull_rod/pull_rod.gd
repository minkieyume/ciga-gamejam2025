extends Interactive

@export var ladder:Sprite2D;

@onready var animation_player:=$AnimationPlayer
#拉杆是否启用
var is_rod_enabled:=false

func _physics_process(_delta: float):
	if Engine.is_editor_hint():
		return
	if is_controlling:
		#player_animations()
		_try_handle_input()

func handle_interaction():
	#空格控制拉杆开闭
	rod_state_switch()
	ladder.ladder_state_switch()
	pass

func rod_state_switch():
	if is_rod_enabled:
		animation_player.play("rod_disabled")
	else :
		animation_player.play("rod_enabled")
	is_rod_enabled=!is_rod_enabled
	
