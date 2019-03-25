extends Node

var cursor_pos
var is_paused
var input_interpreter
var boxman
onready var camera_main = get_node("PausableObjects/CameraMain")

func _init():
	cursor_pos = 0
	is_paused = false
	pass

func _ready():
	get_node("PausableObjects").get_tree().paused = false
	input_interpreter = get_node("./InputInterpreter")
	boxman = get_node("PausableObjects/Boxman")
	boxman.setup(input_interpreter)
	
#	get_node("PausableObjects/Bullet")._initialize(Vector2(1,0), Vector2(0,0))
	pass



func _process(delta):
	read_inputs() # TODO: not really sure why but if I move this to _physics_process, I can't exit to title screen.  Want to.  Investigate later
	pass
	
func _physics_process(delta):
	adjust_camera()
	pass
	
func read_inputs():
	if(is_paused):
		if (Input.is_action_just_pressed("jump")):
			select_option(cursor_pos)
		if (Input.is_action_just_pressed("look_up")):
			cursor_pos -= 1
		else: if (Input.is_action_just_pressed("crouch")):
			cursor_pos += 1
		if (cursor_pos > 2):
			cursor_pos -= 3
		else: if (cursor_pos < 0):
			cursor_pos += 3
		move_cursor(cursor_pos)
	if(Input.is_action_just_pressed("pause")):
		toggle_pause()

func move_cursor(position):
	var cursor_node = get_node("PauseMenu/Cursor")
	if (position == 0):
		cursor_node.position = Vector2(cursor_node.position.x, -114)
	else: if (position == 1):
		cursor_node.position = Vector2(cursor_node.position.x, -27)
	else: if (position == 2):
		cursor_node.position = Vector2(cursor_node.position.x, 62)
	pass

func toggle_pause():
	if(is_paused):
		unpause()
	else:
		pause()

func pause():
	get_node("PauseMenu").position = camera_main.get_camera_screen_center()
	cursor_pos = 0
	move_cursor(cursor_pos)
	get_node("PausableObjects").get_tree().paused = true
	get_node("PauseMenu").visible = true
	is_paused = true

func unpause():
	get_node("PauseMenu").visible = false
	get_node("PausableObjects").get_tree().paused = false
	is_paused = false
	cursor_pos = 0
	
func select_option(position):
	if (position == 0):
		unpause()
	if (position == 1):
		pass
	else: if (position == 2):
		get_tree().change_scene("res://scenes/TitleScreen.tscn")
		get_node("PausableObjects").get_tree().paused = false
		
func adjust_camera():
	camera_main.position = boxman.position