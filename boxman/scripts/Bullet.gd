extends Node2D

var BULLET_SPEED = 92000
var _is_initialized = false
var movement = Vector2(0,0)
var raycast_net

func _ready():
	raycast_net = Array()
	raycast_net.append(get_node("RayCast2D_0"))
	raycast_net.append(get_node("RayCast2D_1"))
	pass

func _initialize(var movement, var shooter_movement):
	if(typeof(movement) != TYPE_VECTOR2):
		pass
	#TODO: Normalize movement vector here
	self.movement = movement * BULLET_SPEED * get_physics_process_delta_time() + shooter_movement
	_is_initialized = true
	
	for raycast in raycast_net:
		raycast.cast_to = movement * BULLET_SPEED * get_physics_process_delta_time() + shooter_movement + Vector2(24,0)
	#self.rotation = 

func _physics_process(delta):
	move()
	pass
	
func collision_check():
	if(_is_initialized):
		for raycast in raycast_net:
			if(raycast.is_colliding()):
				var colliding_object = raycast.get_collider() # get colliding object here
				#snag colliding object's "shootable
				print(colliding_object.name)
	pass
	
func move():
	collision_check()
	self.move_and_slide(movement, Vector2(0,1))