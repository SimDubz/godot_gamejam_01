extends Node3D

@onready var pivot_weapon: Node3D = $island/tower_pivot/pivot_weapon
var castle_canon_scene = preload("res://assets/castle_canon.tscn")



func _ready() -> void:
	""""""
	
	var castle_canon = castle_canon_scene.instantiate()
	pivot_weapon.add_child(castle_canon)
