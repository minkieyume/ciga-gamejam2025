extends Camera2D

var target: Node2D  # 要跟随的目标（如玩家）
@export var smooth_speed: float = 5.0  # 值越大，跟随越快

@export var min_position:Vector2=Vector2(-100,-100)
@export var max_position:Vector2=Vector2(100,100)

func _ready() -> void:
	target=get_parent() as Node2D

func _process(delta):
	if target:
		# 计算目标位置（限制在边界内）
		var target_pos = target.global_position
		target_pos = target_pos.clamp(min_position, max_position)
		
		# 使用 lerp 平滑移动
		global_position = global_position.lerp(target_pos, smooth_speed * delta)
	else:
		print("error")
