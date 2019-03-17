extends Node

onready var chambers = [ get_node("RevolverChamber_0"), get_node("RevolverChamber_1"), get_node("RevolverChamber_2"), get_node("RevolverChamber_3"), get_node("RevolverChamber_4"), get_node("RevolverChamber_5")] 
var active_chamber

func _ready():
	active_chamber = chambers[0]

func fire():
	var is_charged
	is_charged = active_chamber.fire()
	active_chamber = chambers[(chambers.find(active_chamber) + 1) % chambers.size()] 
	
	return is_charged