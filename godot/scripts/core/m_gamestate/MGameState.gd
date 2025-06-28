extends IManager

@export var state_machine: StateMachine
var is_setup = false

func _ready() -> void:
	var launcher = get_tree().current_scene
	launcher.connect("basic_loaded",_manager_setup)

func _manager_setup():
	await state_machine._setup()
	is_setup = true
	
func _process(delta: float) -> void:
	if is_setup:
		state_machine._update(delta)

func _physics_process(delta: float) -> void:
	if is_setup:
		state_machine._fixed_update(delta)
