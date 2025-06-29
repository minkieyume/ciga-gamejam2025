class_name Level
extends Node

@export var player_spawner: PlayerSpawner

@export var LU_position : Array[Vector2]

@export var RD_position : Array[Vector2]

func _enter_tree() -> void:
	_change_camera_limit(0)

func _change_camera_limit(id: int):
	MEventbus.limit_cameraLU = LU_position[id]
	MEventbus.limit_cameraRD = RD_position[id]
