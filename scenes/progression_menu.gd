extends Control

signal continue_game
signal exit_game


func _on_yes_button_pressed() -> void:
	var world = get_tree().get_first_node_in_group("world")
	world.call("reload_game_world")
	print("continue_game")


func _on_no_button_pressed() -> void:
	get_tree().quit()
	#get_tree().change_scene("res://scenes/main_menu.tscn")
