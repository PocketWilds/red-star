extends KinematicBody2D

const node_type = "Dummy"
const HEALTH_MAX = 6

onready var health_counter = get_node("HealthCounter")

var spawn_position = self.position
var is_incapacitated

func _ready():
	is_incapacitated = false
	health_counter._initialize(HEALTH_MAX)

func _physics_process(delta):
	if(health_counter.health_current == 0):
		incapacitate()
	pass

func incapacitate():
	var sprite = get_node("Sprite")
	is_incapacitated = true
	sprite.visible = false
	self.position = spawn_position
	queue_free()
	
func respawn():
	var sprite = get_node("Sprite")	
	self.position = spawn_position
	sprite.visible = true
	is_incapacitated = false
	health_counter.modify_health(HEALTH_MAX)
	
func take_damage(dmg_amount):
	health_counter.modify_health(dmg_amount * -1)
	
func get_type():
	return node_type

func _on_HitboxDummy_area_entered(area):
	var colliding_area_name = area.name
	if(colliding_area_name == "HitboxBullet"):
		take_damage(1)
	else: if (colliding_area_name == "HitboxPlayer"):
		pass
		