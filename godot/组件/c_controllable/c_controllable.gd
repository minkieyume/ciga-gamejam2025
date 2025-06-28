## 可控制组件，满足条件的时候对目标对象进行特殊控制
class_name CControllable
extends IComponent

@export var control_strategy: ControlStrategy

var is_controlling: bool = false

func _ready() -> void:
	for child in get_children():
		if child is ControlStrategy:
			child.c_controllable = self

func _update(delta: float):
	control_strategy._focus_listen(delta)

func _fixed_update(delta: float):
	pass
