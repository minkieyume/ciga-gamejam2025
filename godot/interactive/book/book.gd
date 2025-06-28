## 书:
@tool
extends Interactive

## 可阅读的信息
@export var folding_text: String
@export var unfolding_text: String
@export var is_folding: bool = true:
	set(value):
		is_folding = value
		if is_folding:
			player_sprite.texture = folding_sprite
		else:
			player_sprite.texture = unfolding_sprite

const potion_list_hud_keyword: StringName = "PotionFusion"  ## 书本完成交互后,所需要显示的Hud的关键字
@export var folding_sprite: Texture2D
@export var unfolding_sprite: Texture2D


func _physics_process(_delta: float):
	if Engine.is_editor_hint():
		return
	if is_controlling:
		#player_animations()
		_try_handle_input()


func handle_interaction():
	#处理hud出现的逻辑
	print("与书开始交互")
	## TODO 书本的UI显示
	MUiSpawner._spawn(MUiSpawner.all_hud[potion_list_hud_keyword])


func _try_handle_input():
	if is_controlling:
		if Input.is_action_just_pressed("interact"):
			print("现在与书进行交互")
			handle_interaction()
		# 重置输入缓冲
		ignore_attach_input = false
		if Input.is_action_pressed("attach"):
			print()
			pass
	if can_interact and Input.is_action_just_pressed("dialog"):
		## 这里实现对话逻辑
		var nodes = get_tree().get_nodes_in_group("ui_view")
		if !nodes.is_empty():
			var ballon = nodes[1].get_ballon()
			#ballon.start(dialogue_resource,dialogue_node)
	#if can_possess and event.is_action_just_pressed("interact"):
	##附身
	#set_control(true)
	#emit_signal("possessed")


func attach():
	print("与书开始交互,此时右上角出现正确的药水信息")
	set_control(true)
	if camera:
		camera.enabled = true
	# 设置输入缓冲，避免同一帧内触发disattach
	ignore_attach_input = true
	# 延迟一帧处理输入，避免同一帧内触发disattach
	await get_tree().process_frame


func set_control(state: bool):
	is_controlling = state
