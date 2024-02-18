extends CharacterBody3D


# Base configuration 
var base_speed = 50
var speed = base_speed
var lift_factor = 3.0  
var drag_factor = 0.1 
var brake_drag_factor = 1.0  
var glide_descent_rate = -3.0 
var mouse_sensitivity = 0.03
var pitch = 0.0
var yaw = 0.0
var roll = 0.0
var braking = false
var target_roll = 0.0
var target_yaw = 0.0
var roll_speed = 1.0
var current_speed = 0.0
var kmh_speed = 0.0
var gravity = 6.5
var max_pitch_down = deg_to_rad(-45)
var max_pitch_up = deg_to_rad(30)
var thermal_lift = false # New variable for thermal updrafts
var gravity_effect = 1.0 # Normal gravity
var reduced_gravity_effect = 0.5 # Reduced gravity effect
var gravity_reduction_duration = 2.0 # Duration of reduced gravity in seconds
var gravity_reduction_timer = 0.0 # Timer to track gravity reduction
var normal_speed = 2.0
var boosted_speed = 100 # Adjust as needed for the desired boost effect
var speed_boost_duration = 2.0 # Duration of the speed boost in seconds
var speed_boost_timer = 0.0 # Timer to track the speed boost duration
var lives = 2

signal plane_position_updated(new_position)

func _ready() -> void:
	""""""
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	""""""
	
	handle_input(event)
	
func _physics_process(delta: float) -> void:
	""""""
	
	emit_signal("plane_position_updated", global_transform.origin)
	handle_physics_process(delta)
	move_and_slide()

func _hit_by_projectile():
	lives -= 1
	print(lives)
	if lives <= 0:
		get_tree().quit()

### UTILS FUNCTIONS ###

func handle_input(event) -> void:
	""""""
	
	handle_pitch_and_gravity(event)
	handle_braking(event)
	handle_rotation(event)
	
func handle_pitch_and_gravity(event) -> void:
	""""""
	
	if event is InputEventMouseMotion:
		pitch += deg_to_rad(event.relative.y * mouse_sensitivity)
		pitch = clamp(pitch, max_pitch_down, max_pitch_up)
		if event.relative.y > 0:
			activate_reduced_gravity()
			speed = boosted_speed
			speed_boost_timer = speed_boost_duration
	
func handle_braking(event) -> void:
	""""""
	
	if Input.is_action_pressed("ui_accept"):
		braking = true
	elif Input.is_action_just_released("ui_accept"):
		braking = false

func handle_rotation(event) -> void:
	""""""
	
	if Input.is_action_just_pressed("rotate_left"):
		target_roll = deg_to_rad(45)
		target_yaw  += deg_to_rad(10)
	elif Input.is_action_just_pressed("rotate_right"):
		target_roll = deg_to_rad(-45)
		target_yaw  += deg_to_rad(-10)


func handle_physics_process(delta: float) -> void:
	""""""
	
	manage_timers(delta)
	apply_gravity(delta)
	calculate_speed(delta)
	simulate_lift_and_drag(delta)
	apply_movement_and_rotation(delta)
	
func manage_timers(delta: float) -> void:
	""""""
	
	if gravity_reduction_timer > 0:
		gravity_reduction_timer -= delta
		if gravity_reduction_timer <= 0:
			gravity_effect = 1.0
	
	if speed_boost_timer > 0:
		speed_boost_timer -= delta
		if speed_boost_timer <= 0:
			speed = normal_speed
	
func apply_gravity(delta: float) -> void:
	""""""
	
	velocity.y -= gravity * delta
	var effective_gravity = gravity * gravity_effect
	velocity.y -= effective_gravity * delta
	
func calculate_speed(delta: float) -> void:
	""""""
	
	current_speed = velocity.length()
	kmh_speed = units_per_second_to_kmh(current_speed)
	
func simulate_lift_and_drag(delta: float) -> void:
	""""""
	
	var flat_forward_velocity = Vector3(velocity.x, 0, velocity.z).length()
	var lift = max(0, flat_forward_velocity * lift_factor * max(cos(pitch), 0))
	velocity.y -= lift * delta
	velocity = simulate_drag(velocity, delta)

func apply_movement_and_rotation(delta: float) -> void:
	""""""
	
	speed = min(base_speed + sin(pitch) * 5, 50.0)
	var forward_speed = speed + (sin(pitch) * glide_descent_rate)
	forward_speed = max(forward_speed, speed)
	var forward_direction = -transform.basis.z.normalized()
	velocity += forward_direction * forward_speed * delta
	if not braking:
		velocity += forward_direction * speed * delta
	else:
		velocity -= forward_direction * speed * delta
	pass
	
	if not Input.is_action_pressed("rotate_left") and not Input.is_action_pressed("rotate_right"):
		target_roll = 0.0
		
	roll = lerp(roll, target_roll, roll_speed * delta)
	yaw = lerp(roll, target_yaw, roll_speed * delta)
	rotation.x = pitch
	rotation.y = yaw
	rotation.z = roll
	
func units_per_second_to_kmh(units_per_second: float) -> float:
	""""""
	
	return units_per_second * 3.6


func simulate_drag(velocity: Vector3, delta: float) -> Vector3:
	""""""
	
	var speed = velocity.length()
	var drag_magnitude = speed * speed * (drag_factor + (brake_drag_factor if braking else 0))
	var drag_force = velocity.normalized() * drag_magnitude * delta
	velocity -= drag_force
	return velocity
	
func activate_reduced_gravity() -> void:
	""""""
	
	gravity_effect = reduced_gravity_effect
	gravity_reduction_timer = gravity_reduction_duration
