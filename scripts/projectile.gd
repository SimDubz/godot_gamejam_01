extends Area3D

@export var speed = 50.0
var direction = Vector3.FORWARD

func _ready() -> void:
	$Timer.start()
	
func _physics_process(delta: float) -> void:
	# Move the projectile
	var velocity = direction.normalized() * speed
	translate(velocity * delta)

func _on_body_entered(body: Node3D) -> void:
	queue_free()

### UTILS FUNCTIONS ###

func set_direction(new_direction: Vector3) -> void:
	direction = new_direction

func _on_timer_timeout() -> void:
	queue_free()
