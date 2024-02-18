extends Area3D

signal planeLanded

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("plane"):
		print("Landed")
		emit_signal("planeLanded")
