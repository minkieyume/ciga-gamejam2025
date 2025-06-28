extends Area2D

var owneer:Node

func _ready() -> void:
	var parent = get_parent()
	if parent:
		owner=parent

func get_owneer():
	return owneer
