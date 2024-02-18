extends Area3D
@onready var anchor: Node3D = $Anchor
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var speed = 50.0
var projectil_canon_scene = preload("res://assets/Projectile_Cannonball.tscn")
var projectil_arrow_scene = preload("res://assets/Projectile_Arrow.tscn")
var direction = Vector3.FORWARD

func _ready() -> void:
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	# Move the projectile
	var velocity = direction.normalized() * speed
	translate(velocity * delta)
	

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("plane"):
		body._hit_by_projectile()
		queue_free()

### UTILS FUNCTIONS ###

func set_properties(new_direction: Vector3, projectile_type: GameData.WEAPON) -> void:
	direction = new_direction.normalized()
	
	var projectile_instance
	if projectile_type == GameData.WEAPON.CANON:
		projectile_instance = projectil_canon_scene.instantiate()
	elif projectile_type == GameData.WEAPON.ARROW:
		projectile_instance = projectil_arrow_scene.instantiate()
	
	if projectile_instance:
		anchor.add_child(projectile_instance)
		collision_shape_3d.scale = projectile_instance.scale
		var target_look_at = projectile_instance.global_transform.origin - direction
		projectile_instance.look_at(target_look_at, Vector3.UP)
		
		# If additional setup is needed, do it here

func _on_timer_timeout() -> void:
	queue_free()
