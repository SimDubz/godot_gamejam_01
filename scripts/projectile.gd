extends Area3D
@onready var anchor: Node3D = $Anchor
@onready var collision_shape_3d: CollisionShape3D = $CollisionShape3D
@export var speed = 50.0
var projectil_canon_scene = preload("res://assets/Projectile_Cannonball.tscn")
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
	direction = new_direction
	
	if projectile_type == GameData.WEAPON.CANON:
		var projectile_canon = projectil_canon_scene.instantiate()
		anchor.add_child(projectile_canon)
		collision_shape_3d.scale = projectile_canon.scale
		

func _on_timer_timeout() -> void:
	queue_free()
