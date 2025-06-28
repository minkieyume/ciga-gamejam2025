@tool
class_name GamingHsm
extends StateMachine

var update_trigger = false

func _enter():
	super._enter()
	
func _update(delta: float) -> void:
	if (update_trigger):
		state_transition.emit(parent_to_self, "")

func _exit():
	update_trigger = false
