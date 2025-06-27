class_name MLevel
extends IManager

signal level_loaded(target_level_packedscene: PackedScene)

var current_level: Level

## 关卡加载，与将旧关卡卸载
func _on_level_loaded(target_level_packedscene: PackedScene) -> void:
	current_level.queue_free()
	var new_level =  target_level_packedscene.instantiate() as Level
	MEventbus.add_child(new_level)
	current_level = new_level
