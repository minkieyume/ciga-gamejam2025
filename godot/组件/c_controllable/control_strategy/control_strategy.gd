## 控制策略的基类，用于在玩家成功操控目标之后的特殊操作逻辑，如幽灵的鼠标操控，眼球的8向移动
class_name ControlStrategy
extends Node

var c_controllable: CControllable

func _focus_listen(_delta: float):
	var a =  Input.get_vector("Left", "Right", "Up", "Down")
	
