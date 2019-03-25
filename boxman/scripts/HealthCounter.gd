extends Node

var HEALTH_MAX
var health_current

func _ready():
	pass

func _initialize(health_max):
	self.HEALTH_MAX = health_max
	health_current = self.HEALTH_MAX

func _physics_process(delta):
	pass
	
func modify_health(amount):
	health_current += amount
	_validate()
	
func _validate():
	if(health_current > HEALTH_MAX):
		health_current = HEALTH_MAX
	else: if (health_current < 0):
		health_current = 0