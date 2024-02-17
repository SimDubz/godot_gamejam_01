extends Area3D

signal planeLanded


func _on_body_entered(body: Node3D) -> void:
	emit_signal("planeLanded")
