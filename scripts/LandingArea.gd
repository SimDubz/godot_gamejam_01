extends Area3D

signal planeLanded

var win_effect_scene = preload("res://arts/vfx/vfx_AnitaMaxWin.tscn")

func _on_body_entered(body: Node3D) -> void:
	""""""
	
	if body.is_in_group("plane"):
		print("Landed")
		emit_signal("planeLanded")
		var win_effect = win_effect_scene.instantiate()
		get_tree().get_first_node_in_group("landing").add_child(win_effect)
		
