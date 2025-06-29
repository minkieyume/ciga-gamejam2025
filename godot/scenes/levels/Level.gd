class_name Level
extends Node

@export var player_spawner: PlayerSpawner

@export var LU_position : Vector2:
	set(value):
		MEventbus.limit_cameraLU = value
		LU_position = value
@export var RD_position : Vector2:
	set(value):
		MEventbus.limit_cameraRD = value
		RD_position = value
