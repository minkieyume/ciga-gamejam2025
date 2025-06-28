## 用于交互的Area2D，player基于它了解自己所链接的对象
extends Area2D


func get_owneer():
	return get_parent() as Interactive
