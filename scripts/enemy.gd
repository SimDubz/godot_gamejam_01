extends CharacterBody3D

@onready var canon_edge: Marker3D = $CharacterModel/CanonEdge
var projectile_scene = preload("res://scenes/projectile.tscn")
var plane_in_bounds = false


func _on_shoot_timer_timeout():
	""""""
	
	if plane_in_bounds:
		shoot_at_plane()
		
func _on_range_body_entered(body: Node3D):
	""""""
	
	print("Plane Entered")
	if body.is_in_group("plane"):
		plane_in_bounds = true


func _on_range_body_exited(body: Node3D) -> void:
	""""""
	
	print("Plane Existed")
	if body.is_in_group("plane"):
		plane_in_bounds = false
		
### UTILS FUNCTIONS ###

func shoot_at_plane():
	""""""
	
	var player = get_tree().get_nodes_in_group("plane")[0]
	if player:
		var player_position = get_plane_position()
		var player_velocity = player.velocity
		var projectile = projectile_scene.instantiate()
		var future_position = get_refined_future_position(player_position, player_velocity, projectile.speed)
		var direction = (future_position - canon_edge.global_transform.origin).normalized()

		get_tree().root.add_child(projectile)
		projectile.global_transform.origin = canon_edge.global_transform.origin
		projectile.call("set_direction", direction)
	else:
		print("Player not found, cannot shoot at plane.")
	
	
func get_plane_position() -> Vector3:
	""""""
	
	var player = get_tree().get_nodes_in_group("plane")[0]
	if player:
		return player.global_position
	return Vector3()
	
func get_refined_future_position(player_position, player_velocity, projectile_speed):
	""""""
	
	var initial_prediction = get_future_player_position(player_position, player_velocity, projectile_speed)
	# Iterative refinement could go here, for now we use initial prediction
	
	return initial_prediction

	
func get_future_player_position(
	player_position: Vector3,
	player_velocity: Vector3,
	projectile_speed: float) -> Vector3:
	""""""
	
	var distance_to_player = player_position.distance_to(canon_edge.global_transform.origin)
	var time_to_hit = distance_to_player / projectile_speed
	var future_position = player_position + player_velocity * time_to_hit
	
	# Additional refinements based on player's current action, acceleration, etc.
	
	return future_position
	
	





