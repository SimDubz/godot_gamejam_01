extends Area3D

var projectil_flame_scene = preload("res://arts/vfx/vfx_Flametrower.tscn")
@onready var anchor: Node3D = $Anchor

func _ready() -> void:
	%Timer.start()

func set_properties():
	var projectile_instance = projectil_flame_scene.instantiate()
	anchor.add_child(projectile_instance)

func _on_body_entered(body: Node3D) -> void:
	print("Body entered")
	if body.is_in_group("plane"):
		body._hit_by_projectile()
		queue_free()


func _on_timer_timeout() -> void:
	var fire_effects = get_tree().get_first_node_in_group("fire_effect")
	for fire_effect in fire_effects.get_children():
		queue_free()
	
