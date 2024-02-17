extends Node3D
#
#var castle_scene = preload("res://scenes/enemy.tscn")
#var player_scene = preload("res://scenes/player.tscn")
#var landing_zone_scene = preload("res://scenes/landing_zone.tscn")
#
#var min_castles = 3
#var castle_increase_per_landing = 1
#var current_landings = 0
#var max_distance = 1000
#var min_distance = 500
#var starting_position = Vector3(0, 0, 0)
#
#func _ready():
	#print("ready")
	#generate_world()
#
#
#func generate_world():
	#var total_castles = min_castles + current_landings + castle_increase_per_landing
	#for i in range (total_castles):
		#spawn_castle()
	#spawn_landing_zone()
	#spawn_player()
		#
#func spawn_player():
	#var player_instance = player_scene.instantiate()
	#player_instance.global_transform.origin = Vector3(0, 10, 0)
	#get_tree().root.add_child(player_instance)
	#print("Player Spawn")
		#
#func spawn_castle():
	#print("spawning castles")
	#var angle_degress = randf_range(0, 360)
	#var distance = randf_range(min_distance, max_distance)
	#var angle_radian = deg_to_rad(angle_degress)
	#
	#var spawn_position = Vector3(cos(angle_radian), 0 , sin(angle_radian)) * distance
	#spawn_position += starting_position
	#
	#var castle_instance = castle_scene.instantiate()
	#castle_instance.global_transform.origin = spawn_position
	#get_tree().root.add_child(castle_instance)
#
#func spawn_landing_zone():
	#print("spawning landing zone")
	#var angle_degrees = 180
	#var distance = max_distance
	#var angle_radians = deg_to_rad(angle_degrees)
	#
	#var spawn_position = Vector3(cos(angle_radians), 0 , sin(angle_radians)) * distance
	#var landing_zone_instance = landing_zone_scene.instantiate()
	#landing_zone_instance.global_transform.origin = spawn_position
	#get_tree().root.add_child(landing_zone_instance)
#
#func on_player_landed():
	#current_landings +=1
	#regenerate_world()
	#
#func regenerate_world():
	#var player = get_tree().get_nodes_in_group("plane")
	#player.queue_free()
	#var landing_zone = get_tree().get_nodes_in_group("landing")
	#landing_zone.queue_free()
	#for castle in get_tree().get_nodes_in_group("castles"):
		#castle.queue_free()
	#
	#
		#
	#generate_world()
#
