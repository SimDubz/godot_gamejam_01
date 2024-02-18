extends Node3D

@export var aim_speed = 10.0
@export var aim_limit = 300.0
@onready var pivot_weapon: Node3D = $island/tower_pivot/pivot_weapon
@onready var tower_pivot: MeshInstance3D = $island/tower_pivot
@onready var aim_start = $island/aim_start
var castle_canon_scene = preload("res://assets/castle_canon.tscn")
var castle_ballista_scene = preload("res://assets/castle_ballista.tscn")
var castle_flamethrower_scene = preload("res://assets/castle_flamethrower.tscn")
var aim_enabled = false
var player_body: Node3D = null

var weapons_scene = [castle_canon_scene, castle_ballista_scene, castle_flamethrower_scene]

func _ready() -> void:
	""""""

	randomize()
	
	var random_index = randi() % weapons_scene.size()
	var random_scene = weapons_scene[random_index]
	var weapon_instance = random_scene.instantiate()
	
	pivot_weapon.add_child(weapon_instance)

func _physics_process(delta):
	if aim_enabled:
		aim_player(aim_speed * delta)
		
func enable_aim(body):
	player_body = body
	aim_enabled = true
	
func aim_player(speed):
	if not player_body:
		return
	var distance = aim_start.global_transform.origin.distance_to(player_body.global_transform.origin)
	if distance > aim_limit:
		return
	aim_start.look_at(player_body.global_transform.origin, Vector3.FORWARD)
	pivot_weapon.global_rotation_degrees.x = aim_start.global_rotation_degrees.x *-1
	tower_pivot.global_rotation_degrees.y = aim_start.global_rotation_degrees.y + 180
	
