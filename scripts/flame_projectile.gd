extends Area3D

var projectil_flame_scene = preload("res://arts/vfx/vfx_Flametrower.tscn")
@onready var anchor: Node3D = $Anchor


func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("plane"):
		body._hit_by_projectile()

