extends "res://World 1/LoadScene.gd"

export(String) var game_over_scene

#onready var player = $YSort/Player
#onready var boss = $Boss

func _on_Boss_dead():
	fade.show()
	fade.fade_in()

func _on_Player_dead():
	scene_to_load = game_over_scene
	fade.show()
	fade.fade_in()
