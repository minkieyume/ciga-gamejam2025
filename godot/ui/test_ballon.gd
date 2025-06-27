extends Node

@onready var ballon = $Ballon

var dialogue_resource = preload("res://dialogue/test.dialogue")

func _ready() -> void:
	ballon.start(dialogue_resource, "start")
