extends Node3D

var castle_scene = preload("res://scenes/enemy.tscn")
var player_scene = preload("res://scenes/player.tscn")
var landing_zone_scene = preload("res://scenes/landing_zone.tscn")
var continue_menu_scene  = preload("res://scenes/progression_menu.tscn")
var user_interface_scene  = preload("res://scenes/user_interface.tscn")
var clouds_scene  = preload("res://arts/vfx/vfx_Clouds01.tscn")
var explosion_scene = preload("res://arts/vfx/vfx_Explosion.tscn")
var cube_size = 400
var box_center = Vector3.ZERO
var box_extents = Vector3(cube_size, cube_size, cube_size)
var min_castles = 4
var castle_increase_per_landing = 1
var successful_landings = GameData.get_successful_landings()
var max_distance = 1000
var min_distance = 500
var min_distance_between_castles = 200.0
var total_castles = min_castles + successful_landings + castle_increase_per_landing
var landing_zone_position = Vector3(
	randf_range(-cube_size / 4.0, cube_size / 4.0), -cube_size / 2.0, -cube_size / 2.0
	)
var grid_size = 20.0 
var grid = {}

func _ready():
	""""""
	
	generate_world()
	set_player_position()
	set_landing_position()
	set_castles_position()
	set_clouds_position()
	connect_landing_signal()
	
	

func _physics_process(delta: float) -> void:
	""""""

	var player = get_tree().get_first_node_in_group("plane")
	if player and is_object_out_of_bounds(player.global_transform.origin):
		
		var explosion = explosion_scene.instantiate()
		player.add_child(explosion)
		for i in range(explosion.get_children().size()):
			var effect = explosion.get_child(i)
			effect.emitting = true
			
		
		var timer = get_tree().create_timer(1.0)
		await timer.timeout
		
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		
### UTILS FUNCTIONS ###
	

func world_to_grid(position):
	""""""
	
	var x = floor(position.x / grid_size)
	var y = floor(position.y / grid_size)
	var z = floor(position.z / grid_size)
	return Vector3(x, y, z)

func generate_world():
	""""""
	
	spawn_player()
	spawn_castle()
	spawn_landing_zone()
	spawn_clouds(7)
	spaw_user_interface()

func connect_landing_signal():
	""""""
	
	var landing_zone =  get_tree().get_first_node_in_group("landing")
	var landing_area = landing_zone.get_child(0)
	landing_area.connect("planeLanded", player_landed)
	
func set_clouds_position():
	""""""
	
	var clouds = get_tree().get_nodes_in_group("clouds")
	
	for cloud in clouds:
		var min_x = -cube_size / 2.0
		var max_x = cube_size / 2.0
		var min_y = -cube_size / 4.0 # Adjust to ensure castles are between player and landing zone
		var max_y = cube_size / 4.0
		var min_z = 0.0  # Start from player's depth
		var max_z = cube_size / 2.0  # Up to halfway to the landing zone

		var spawn_position = Vector3(
			randf_range(min_x, max_x),
			randf_range(min_y, max_y),
			randf_range(min_z, max_z)
		)
		
		cloud.global_transform.origin = spawn_position
	
	
func set_landing_position():
	""""""
	
	var landing_zone =  get_tree().get_first_node_in_group("landing")
	landing_zone.global_transform.origin = landing_zone_position
	
func set_player_position():
	""""""
	
	var player = get_tree().get_first_node_in_group("plane")
	player.global_transform.origin =  Vector3(0, cube_size, cube_size)

func set_castles_position():
	var castles = get_tree().get_nodes_in_group("castles")

	for castle in castles:
		var placed = false
		while not placed:
			var spawn_position = Vector3(
				randf_range(-cube_size / 2.0, cube_size / 2.0),
				randf_range(-cube_size / 4.0, cube_size / 4.0),
				randf_range(0.0, cube_size / 2.0)
			)
			var grid_position = world_to_grid(spawn_position)
			if not grid.has(grid_position):
				grid[grid_position] = true
				castle.global_transform.origin = spawn_position
				placed = true

func spawn_clouds(nbr_of_clouds):
	
	for i in range(nbr_of_clouds):
		var clouds_instance = clouds_scene.instantiate()
		add_child(clouds_instance)
	

		
func spaw_user_interface():
	""""""
	
	var interface_instance = user_interface_scene.instantiate()
	add_child(interface_instance)
	
func spawn_player():
	""""""
	
	var player_instance = player_scene.instantiate()
	add_child(player_instance)
	
func spawn_castle():
	""""""
	
	for i in range(total_castles):
		var castle_instance = castle_scene.instantiate()
		add_child(castle_instance)

func spawn_landing_zone():
	""""""
	
	var landing_zone_instance = landing_zone_scene.instantiate()
	add_child(landing_zone_instance)
	
	return landing_zone_instance
	
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
	
	get_tree().reload_current_scene()
		
func is_object_out_of_bounds(object_position: Vector3) -> bool:
	""""""
	
	var min_bounds = box_center - box_extents
	# Only check the bottom boundary (Y-axis)
	return object_position.y < min_bounds.y
