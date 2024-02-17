extends Node3D

var castle_scene = preload("res://scenes/enemy.tscn")
var player_scene = preload("res://scenes/player.tscn")
var landing_zone_scene = preload("res://scenes/landing_zone.tscn")

var cube_size = 200
var min_castles = 3
var castle_increase_per_landing = 1
var current_landings = 0
var max_distance = 1000
var min_distance = 500
var landing_zone_position = Vector3(randf_range(-cube_size / 2, cube_size / 2), -cube_size / 2, -cube_size / 2)

func _ready():
	print("ready")
	generate_world()
	var player = get_node_or_null("/root/game_world/LandingZone")

func generate_world():
	spawn_player()
	spawn_castle()
	spawn_landing_zone()
	
		
func spawn_player():
	var player_instance = player_scene.instantiate()
	player_instance.global_transform.origin = Vector3(0, cube_size, cube_size)
	
	add_child(player_instance)
	print("Player Spawn")
		
func spawn_castle():
	print("spawning castles")
	var total_castles = min_castles + current_landings + castle_increase_per_landing
	for i in range(total_castles):
		var min_x = -cube_size / 2
		var max_x = cube_size / 2
		var min_y = -cube_size / 4  # Adjust to ensure castles are between player and landing zone
		var max_y = cube_size / 4
		var min_z = 0  # Start from player's depth
		var max_z = cube_size / 2  # Up to halfway to the landing zone

		var spawn_position = Vector3(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y),
			randf_range(min_z, max_z)
		)
	
		var castle_instance = castle_scene.instantiate()
		castle_instance.global_transform.origin = spawn_position
		add_child(castle_instance)

func spawn_landing_zone():
	print("spawning landing zone")
	
	var landing_zone_instance = landing_zone_scene.instantiate()
	landing_zone_instance.global_transform.origin = landing_zone_position
	add_child(landing_zone_instance)
	return landing_zone_instance

func player_landed():
	current_landings +=1
	regenerate_world()
	
func regenerate_world():
	get_tree().call_group("castles", "queue_free")
	get_tree().call_group("landing", "queue_free")
	get_tree().call_group("plane", "queue_free")
	generate_world()
