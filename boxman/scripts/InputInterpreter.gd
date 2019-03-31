extends Node

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

func _physics_process(delta):
	pass

func shoot():
	return Input.is_action_just_pressed("shoot")

func move_left():
	return Input.is_action_pressed("move_left") and !Input.is_action_pressed("move_right")
	
func move_right():
	return Input.is_action_pressed("move_right") and !Input.is_action_pressed("move_left")

func crouch():
	return Input.is_action_just_pressed("crouch")

func jump_begin():
	return Input.is_action_just_pressed("jump")

func jump_hold():
	return Input.is_action_pressed("jump")
	
func jump_release():
	return Input.is_action_just_released("jump")
	
func angle_up():
	return Input.is_action_pressed("aim_up") and !Input.is_action_pressed("aim_down")
	
func angle_down():
	return Input.is_action_pressed("aim_down") and !Input.is_action_pressed("aim_up")
	
func no_input():
	return Input.is_action_pressed("input_monitored")