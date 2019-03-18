extends KinematicBody2D

# begin constants
var MAX_RUN_SPEED = 475
var MAX_FALL_SPEED = 1300
var MAX_JUMP_TIME = 0.28
var RUN_ACCELERATION = 3800
var JUMP_SPEED = 1000
var GRAVITY = 5500
# end constants

var input_interpreter

onready var bullet_scene = preload("../scenes/Bullet.tscn")
onready var revolving_chambers = get_node("RevolvingChambers")
onready var bullets_container = get_node("Bullets")
onready var sprites = get_node("Sprites")

var move_vector
var jump_timer

var is_active
var grounded_lock
var fire_lock
var jump_ended
var modifier_directional_vector
var is_angle_up
var is_angle_down
#var 

func _init():
	is_active = false
	grounded_lock = false
	jump_ended = true
	jump_timer = 0
	modifier_directional_vector = 1
	is_angle_up = false
	is_angle_down = false
	pass

func setup(new_input_interpreter):
	input_interpreter = new_input_interpreter

func _ready():
	is_active = true
	fire_lock = false
	move_vector = Vector2(0, 0)
	pass

func _process(delta):
	pass

func _physics_process(delta):
	move(_read_inputs(), delta)	
	pass
	
func _read_inputs():
	var is_moving_h = true
	if(input_interpreter.move_left()):
		modifier_directional_vector = -1
		if(!sprites.is_flipped_h()):
			sprites.set_flip_h(true)
			for sprite in sprites.get_children():
				sprite.set_flip_h(true)
	else: if(input_interpreter.move_right()):
		modifier_directional_vector = 1
		if(sprites.is_flipped_h()):
			sprites.set_flip_h(false)			
			for sprite in sprites.get_children():
				sprite.set_flip_h(false)
	else:
		is_moving_h = false
	
	var indicator_directional = sprites.get_node("IndicatorDirection")
	if(input_interpreter.angle_up()):
		is_angle_up = true
		indicator_directional.rotation = -45 * modifier_directional_vector
	else: if(input_interpreter.angle_down()):
		is_angle_down = true
		indicator_directional.rotation = 45 * modifier_directional_vector
	else:
		indicator_directional.rotation = 0
		is_angle_up = false
		is_angle_down = false
	
	if(is_moving_h):
		return modifier_directional_vector
	else:
		return 0
	

func move(direction, delta):
	var horizontal_speed
	var vertical_speed = 0

	if(jump_timer > MAX_JUMP_TIME):
		jump_ended = true

	if(check_if_grounded()):
		grounded_lock = true
		jump_timer = 0
		horizontal_speed = (move_vector.x + direction * RUN_ACCELERATION * delta) * (direction * direction) # this calculates velocity with turnaround time
		horizontal_speed = (sqrt(move_vector.x * move_vector.x) + RUN_ACCELERATION * delta) * direction * (direction * direction) # while this calculates with no turnaround time
		horizontal_speed = clamp(horizontal_speed, MAX_RUN_SPEED * -1, MAX_RUN_SPEED)
		if(input_interpreter.jump_begin()):
			grounded_lock = false
			vertical_speed = JUMP_SPEED * -1
			jump_ended = false
		else:
			vertical_speed = 0
			grounded_lock = true
			jump_ended	= true
	else:
		horizontal_speed = MAX_RUN_SPEED * direction
		if(input_interpreter.jump_release() and !jump_ended):
			jump_ended = true
		if(input_interpreter.jump_hold() and !jump_ended):
			vertical_speed = JUMP_SPEED * -1
			jump_timer += delta
		else:
#			if(!grounded_lock): # TODO: Investigate this conditional's potential adverse effects on vertical movement  
				vertical_speed = (move_vector.y + GRAVITY * delta) # this calculates velocity with turnaround time
				vertical_speed = clamp(vertical_speed, JUMP_SPEED * -1, MAX_FALL_SPEED)
	if(input_interpreter.shoot()):
		shoot_bullet()
	move_vector = Vector2(horizontal_speed, vertical_speed) 
	self.move_and_slide(move_vector, Vector2(0,-1))
	pass

func move_cursor(position):
	pass
	
func select_option(position):
	pass
	
func check_if_grounded():
	var is_grounded = false
	var raycast_grounded_0 = get_node("RaycastGrounded0")
	var raycast_grounded_1 = get_node("RaycastGrounded1")
	
	var is_colliding_0 = raycast_grounded_0.is_colliding()
	var is_colliding_1 = raycast_grounded_1.is_colliding()
	
	is_grounded = is_colliding_0 and is_colliding_1
	
	return is_grounded
	
func shoot_bullet():
	if(revolving_chambers.fire()):
		var new_bullet = bullet_scene.instance()
		var modifier_angle
		bullets_container.add_child( new_bullet )
		if(is_angle_up):
			new_bullet.position = self.position + Vector2(60 * modifier_directional_vector, -60)
			new_bullet.z_index = 1
			modifier_angle = -1 * modifier_directional_vector * PI / 4
			new_bullet.rotation = modifier_angle
			new_bullet._initialize(Vector2(modifier_directional_vector,0).rotated(modifier_angle),Vector2(0,0))
		else: if (is_angle_down):
			new_bullet.position = self.position + Vector2(60 * (modifier_directional_vector), 60)
			new_bullet.z_index = 1
			modifier_angle = modifier_directional_vector * PI / 4
			new_bullet.rotation = modifier_angle
			new_bullet._initialize(Vector2(modifier_directional_vector,0).rotated(modifier_angle),Vector2(0,0))
		else:
			new_bullet.position = self.position + Vector2(60, 0) * (modifier_directional_vector)
			new_bullet.z_index = 1
			new_bullet._initialize(Vector2(modifier_directional_vector,0),Vector2(0,0))
		if(sprites.is_flipped_h()):
			var bullet_sprite = new_bullet.get_node("Sprite")
			var bullet_sprite_debug = new_bullet.get_node("Sprite/debug_direction")
			bullet_sprite.set_flip_h(true)
			bullet_sprite_debug.set_flip_h(true)
	else:
		pass