## 这是ECS中组件的基类
class_name IComponent
extends Node

enum ComponentType { BASE = 0, INTERFACE = 1 }

var component_owner: IEntity ## 组件的拥有者
var component_body: CollisionObject2D
var component_type: ComponentType:
	set(value):
		if (Engine.is_editor_hint()):
			component_type = value
		else:
			printerr(
				"该量运行时不可修改。"
			)
	get:
		return component_type

##
func _initialize(_owner: IEntity):
	if Engine.is_editor_hint():
		return
	component_owner = _owner
	component_body = component_owner.body


##
func _late_initialize(_owner: IEntity):
	if Engine.is_editor_hint():
		return
	component_owner = _owner
	component_body = component_owner.body

func _update(delta: float):
	if Engine.is_editor_hint():
		return

func _fixed_update(delta: float):
	if Engine.is_editor_hint():
		return


func _late_update(delta: float):
	if Engine.is_editor_hint():
		return


func _trigger_update():
	if Engine.is_editor_hint():
		return


func _exit_tree() -> void:
	return
