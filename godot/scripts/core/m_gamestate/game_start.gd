## 进入游戏主菜单阶段
### 不会初始化地图，会在接收到游戏开始的信号后自动退出
@tool
class_name GameStartState
extends State

var update_trigger = false


func _enter():
	MUiSpawner._setup()


func _update(_delta: float) -> void:
	if update_trigger:
		state_transition.emit(parent_to_self, "")


func _exit():
	update_trigger = false
