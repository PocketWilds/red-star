extends Node

var cursor_pos

func _init():
	set_physics_process(true)
	cursor_pos = 0
	pass

func _ready():
	pass

func _process(delta):
	read_inputs()
	move_cursor(cursor_pos)
	pass
	
func read_inputs():
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

func move_cursor(position):
	var cursor_node = get_node("Cursor")
	if (position == 0):
		cursor_node.position = Vector2(cursor_node.position.x, 600)
	else: if (position == 1):
		cursor_node.position = Vector2(cursor_node.position.x, 690)
	else: if (position == 2):
		cursor_node.position = Vector2(cursor_node.position.x, 780)
	pass
	
func select_option(position):
	if (position == 0):
		get_tree().change_scene("res://scenes/Level_00.tscn")
	else: if (position == 1):
		pass
	else: if (position == 2):
		get_tree().quit()