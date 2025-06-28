class_name GamingPause
extends State

var update_trigger = false

func _update(delta: float) -> void:
	if (update_trigger):
		state_transition.emit(parent_to_self, "")

func _exit():
	update_trigger = false
