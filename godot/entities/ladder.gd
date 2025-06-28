extends Sprite2D

#梯子是否启用
var is_ladder_enabled:=false;

@onready var animation_player:=$AnimationPlayer

func ladder_state_switch():
	if is_ladder_enabled:
		animation_player.play("disable_the_ladder")
		pass
	else:
		animation_player.play("enable_the_ladder")
		pass
	is_ladder_enabled=!is_ladder_enabled
