extends IManager

@export var state_machine: StateMachine

func _ready() -> void:
	state_machine._setup()

func _process(delta: float) -> void:
	state_machine._update(delta)

func _physics_process(delta: float) -> void:
	state_machine._fixed_update(delta)
