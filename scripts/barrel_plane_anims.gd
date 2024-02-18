extends Node3D

enum BONES {root, propeller, wing_pivot, wing_l, wing_r}
@export var rig: Skeleton3D =  null
@export var propeller_speed = 160.0
@export var target_rotation_l = Quaternion(-0.5,-0.615,0.129,0.991)
@export var target_rotation_r = Quaternion(-0.5,0.615,0.129,0.991)
@onready var node_3d = get_parent_node_3d()
var bones = {BONES.root: "root",BONES.propeller: "propeller", BONES.wing_pivot: "wings_pivot", BONES.wing_l: "wing_l", BONES.wing_r: "wing_r"}
var wing_origin_l
var wing_origin_r
var wing_pivot_origin


func _ready():
	if not rig:
		return
	for bone in bones:
		var bone_idx = rig.find_bone(bones[bone])
		if not rig.find_bone(bones[bone]):
			bones[bone] = null
		else:
			bones[bone] = bone_idx
			
	wing_origin_l = rig.get_bone_pose_position(bones[BONES.wing_l])
	wing_origin_r = rig.get_bone_pose_position(bones[BONES.wing_r])


func _process(delta):
	if not rig:
		return
	rotate_propeller((propeller_speed * -1) * delta)
	move_wings()


func rotate_propeller(speed: float):
	var axis = Vector3(0, 1, 0)
	var bone_rotation: Quaternion = rig.get_bone_pose_rotation(bones[BONES.propeller])
	var new_bone_global_rotation: Quaternion = Quaternion(axis, speed) * bone_rotation
	var new_bone_rotation: Quaternion =new_bone_global_rotation 

	rig.set_bone_pose_rotation(bones[BONES.propeller], new_bone_rotation)
	
	
func move_wings():
	var driver_values_z = node_3d.global_rotation.y *1.25
	var driver_values_y = (driver_values_z * 0.5)
	var target_pos_l = wing_origin_l + Vector3(0,driver_values_y,driver_values_z * -1)
	var target_pos_r = wing_origin_r + Vector3(0,driver_values_y* -1, driver_values_z)
	rig.set_bone_pose_position(bones[BONES.wing_l], target_pos_l)
	rig.set_bone_pose_position(bones[BONES.wing_r], target_pos_r)
	
	var pitch = node_3d.global_rotation.x
	var current_pivot = rig.get_bone_pose_rotation(bones[BONES.wing_pivot])
	current_pivot.x = pitch * 0.3
	rig.set_bone_pose_rotation(bones[BONES.wing_pivot], current_pivot)
	
