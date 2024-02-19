extends Node3D

@onready var character_model: Node3D = $"../CharacterModel"
@onready var camera: Camera3D = %Camera3D

var offset = Vector3(0, 1, 1)
var camera_speed = 4.0
var rotation_speed = 0.1
var max_fov_increase = 100.0
var base_fov = 75.0
var previous_pitch = 0.0

func _process(delta):
	""""""
	
	if character_model:
		# Positioning the camera behind the target
		var desired_position = character_model.global_transform.origin + offset
		global_transform.origin = global_transform.origin.lerp(desired_position, camera_speed * delta)

		# Mimicking target's pitch and roll
		var target_rotation = character_model.rotation_degrees
		var desired_rotation = Vector3(target_rotation.x * 0.5, target_rotation.y, target_rotation.z * 0.5) # Mimic 50% of pitch and roll
		rotation_degrees = rotation_degrees.lerp(desired_rotation, rotation_speed * delta)
		
		
