extends Node

const threshold_recharge = 2
var timer_recharge

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	timer_recharge = 2
	
	pass

func _physics_process(delta):
	timer_recharge += delta
	pass

func fire():
	var is_charged = (timer_recharge >= threshold_recharge)
	timer_recharge = 0
	return is_charged