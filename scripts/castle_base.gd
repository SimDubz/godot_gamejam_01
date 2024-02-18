extends Node3D

@onready var pivot_weapon: Node3D = $island/tower_pivot/pivot_weapon
var castle_canon_scene = preload("res://assets/castle_canon.tscn")
var castle_ballista_scene = preload("res://assets/castle_ballista.tscn")
var castle_flamethrower_scene = preload("res://assets/castle_flamethrower.tscn")

var weapons_scene = [castle_canon_scene, castle_ballista_scene]

func _ready() -> void:
	""""""

	randomize()
	
	var random_index = randi() % weapons_scene.size()
	var random_scene = weapons_scene[random_index]
	var weapon_instance = random_scene.instantiate()
	
	pivot_weapon.add_child(weapon_instance)
