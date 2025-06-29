extends Control

@onready var intro_components:=$IntroComponents

#当前播放到的幻灯片
var current_slide:int=-1
var slide_name:String
const SLIDE_SIZE:=4

func _ready() -> void:
	current_slide=0
	for i:int in range(0,SLIDE_SIZE):
		slide_name="Slide"+str(i)
		intro_components.get_node(slide_name).hide()
	#intro_components.get_node("WallCraps").hide()
	#for child:TextureRect in intro_components.get_node("Window").get_children(false):
		#child.hide()
	#intro_components.get_node("SpidersNet").hide()
	#intro_components.get_node("Witch").hide()
	
# 处理幻灯片显示顺序
func handle_scheduling() :
	#match current_slide:
		#0:
			#for child:TextureRect in intro_components.get_node("Window").get_children(false):
				#child.show()
		#1:
			#intro_components.get_node("Witch").show()
		#2:
			#intro_components.get_node("WallCraps").show()
		#3:
			#intro_components.get_node("SpidersNet").show()
		#_:
			#pass
	if current_slide>0:
		slide_name="Slide"+str(current_slide-1)
		intro_components.get_node(slide_name).hide()
	if current_slide == 1:
		$IntroComponents/Slide1/AnimationPlayer.play("spark")
	if current_slide==2:
		$IntroComponents/Slide2/AudioStreamPlayer.play()
	slide_name="Slide"+str(current_slide)
	intro_components.get_node(slide_name).show()
	
	intro_components
	current_slide+=1
			
func _input(event):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if current_slide < SLIDE_SIZE :
			handle_scheduling()
		else:
			#TODO: 幻灯片播放结束，进入游戏场景
			print("幻灯片播放结束")
