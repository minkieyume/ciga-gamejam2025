@tool
extends Interactive

@export var size: Vector2:
	set(value):
		size = value
		if (Engine.is_editor_hint()):
			update_size()
		
		
		
@export var body_collision_shape: CollisionShape2D
@export var areashape: RectangleShape2D

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	super._ready()
	update_size()


# 更新碰撞体和纹理
func update_size():
	# 更新碰撞体（假设使用矩形碰撞盒）
	var shape = RectangleShape2D.new()
	shape.size = size
	$CollisionShape2D.shape = shape
	$SelfArea/CollisionShape2D.shape = shape
	$InteractArea/CollisionShape2D.shape = shape

	# 更新纹理尺寸
	player_sprite.scale = size / player_sprite.texture.get_size()
