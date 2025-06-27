extends IManager

signal player_located(target_nodetarget_position: Vector2)
signal player_located_finished

@export var player_scene: PackedScene
var player_static ## 玩家的静态指针，始终指向玩家

func _setup():
	player_located.connect(_on_player_located)

func _on_player_located(target_node:Node,  target_position:Vector2):
	if (player_static != null):
		player_static.reparent(target_node)
	else:
		player_static = player_scene.instantiate()
		target_node.add_child(player_static)
	player_static.main_control.global_position = target_position
	player_located_finished.emit()
