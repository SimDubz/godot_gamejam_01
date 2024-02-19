extends Node

enum WEAPON {CANON, ARROW, FIRE}
var successful_landings = 12
var lives = 2

func increment_landings():
	""""""
	
	successful_landings += 1

func get_successful_landings():
	""""""
	
	return successful_landings
	
func reset_successful_landings():
	successful_landings = 0
	
