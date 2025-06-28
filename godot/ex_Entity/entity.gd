@tool
## 实体组件, 本身是一个平台
class_name IEntity
extends Node2D

@export_subgroup("依赖")
@export var main_control: Node2D ## 主要控制对象
@export var component_container: Node2D
var body: CollisionObject2D:
	get:
		return get_child(0) 

var list_base_components: Array[IComponent] = [] ## 基础组件组
var list_interface_components: Array[IComponent] = [] ## 接口组件组

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	var player = MPlayerStatic
	player.player_located_finished.connect(_initialize)

func _initialize():
	for component in component_container.get_children():
		if (component is IComponent):
			if (component.component_type == 0):
				list_base_components.append(component)
				component._initialize(self)
			else:
				list_interface_components.append(component)
				component._late_initialize(self)

func _process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	for base in list_base_components:
		base._update(delta)


func _physics_process(delta: float) -> void:
	if Engine.is_editor_hint():
		return
	for base in list_base_components:
		base._fixed_update(delta)
