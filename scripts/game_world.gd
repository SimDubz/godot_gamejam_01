extends Node3D

var castle_scene = preload("res://scenes/enemy.tscn")
var player_scene = preload("res://scenes/player.tscn")
var landing_zone_scene = preload("res://scenes/landing_zone.tscn")
var continue_menu_scene  = preload("res://scenes/progression_menu.tscn")
var cube_size = 400
var box_center = Vector3.ZERO
var box_extents = Vector3(cube_size, cube_size, cube_size)
var min_castles = 5
var castle_increase_per_landing = 1
var successful_landings = GameData.get_successful_landings()
var max_distance = 1000
var min_distance = 500
var landing_zone_position = Vector3(
	randf_range(-cube_size / 4, cube_size / 4), -cube_size / 2, -cube_size / 2
	)

func _ready():
	""""""
	
	generate_world()
	var landing_zone = get_tree().get_nodes_in_group("landing")[0]
	var landing_area = landing_zone.get_child(1)
	landing_area.connect("planeLanded", player_landed)

func _physics_process(delta: float) -> void:
	""""""
	
	var player = get_tree().get_first_node_in_group("plane")
	if player and is_object_out_of_bounds(player.global_transform.origin):
		show_continue_menu()
		
### UTILS FUNCTIONS ###

func generate_world():
	""""""
	
	spawn_player()
	spawn_castle()
	spawn_landing_zone()
	
func spawn_player():
	""""""
	
	var player_instance = player_scene.instantiate()
	player_instance.global_transform.origin = Vector3(0, cube_size, cube_size)
	add_child(player_instance)
		
func spawn_castle():
	""""""
	
	var total_castles = min_castles + successful_landings + castle_increase_per_landing
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
	""""""
	
	var landing_zone_instance = landing_zone_scene.instantiate()
	landing_zone_instance.global_transform.origin = landing_zone_position
	add_child(landing_zone_instance)
	return landing_zone_instance
	
func regenerate_world():
	""""""
	
	get_tree().call_group("plane", "queue_free")
	get_tree().call_group("castles", "queue_free")
	get_tree().call_group("landing", "queue_free")
	generate_world()
	
func player_landed():
	""""""
	
	GameData.increment_landings()
	show_continue_menu()
	
func show_continue_menu():
	""""""
	
	var menu = continue_menu_scene.instantiate()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	add_child(menu)

func reload_game_world():
	""""""
	
	var current_scene = get_tree().current_scene
	get_tree().reload_current_scene()
		
func is_object_out_of_bounds(object_position: Vector3) -> bool:
	""""""
	
	var min_bounds = box_center - box_extents
	var max_bounds = box_center + box_extents
	var is_out_of_bound = false
	
	if object_position.x < min_bounds.x:
		is_out_of_bound = true
	elif object_position.x > max_bounds.x:
		is_out_of_bound = true
	elif object_position.x > max_bounds.x:
		is_out_of_bound = true
	elif object_position.y < min_bounds.y:
		is_out_of_bound = true
	elif object_position.y > max_bounds.y:
		is_out_of_bound = true
	elif object_position.z < min_bounds.z:
		is_out_of_bound = true
	elif object_position.z > max_bounds.z:
		is_out_of_bound = true
		
	return is_out_of_bound
