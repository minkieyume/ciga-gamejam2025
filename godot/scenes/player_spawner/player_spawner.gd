class_name PlayerSpawner
extends Marker2D

func spawn():
	var player = get_tree().get_first_node_in_group("Player")
	player.respawn(position)
