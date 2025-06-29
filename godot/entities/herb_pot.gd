extends Area2D

@export var final_ui: PackedScene


func _on_body_entered(body: Node2D) -> void:
	if body is HerbBottle:
		MUiSpawner._spawn(final_ui)
