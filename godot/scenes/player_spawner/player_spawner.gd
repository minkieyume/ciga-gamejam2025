class_name PlayerSpawner
#extends Marker2D
extends Node2D

func spawn():
	var player = get_tree().get_first_node_in_group("Player")
	player.respawn(global_position)
