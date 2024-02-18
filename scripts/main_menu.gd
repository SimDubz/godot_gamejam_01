extends Control

func _ready():
	""""""
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_play_button_pressed() -> void:
	""""""
	
	get_tree().change_scene_to_file("res://scenes/game_world.tscn")
	GameData.reset_successful_landings()

func _on_exit_button_pressed() -> void:
	""""""
	
	get_tree().quit()
