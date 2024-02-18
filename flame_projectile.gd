extends Area3D

var projectil_flame_scene = preload("res://assets/castle_flamethrower.tscn")
@onready var anchor: Node3D = $Anchor

func set_properties():
	var projectile_instance = projectil_flame_scene.instantiate()
	anchor.add_child(projectile_instance)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("plane"):
		body._hit_by_projectile()
		queue_free()
