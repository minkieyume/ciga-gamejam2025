@tool
class_name State
extends Node

signal state_transition(from: NodePath, keyword: StringName)

var parent_to_self: NodePath


func _enter_tree() -> void:
	parent_to_self = get_parent().get_path_to(self)


func _enter():
	pass


func _update(_delta: float) -> void:
	pass


func _fixed_update(_delta: float) -> void:
	pass


func _exit():
	pass
