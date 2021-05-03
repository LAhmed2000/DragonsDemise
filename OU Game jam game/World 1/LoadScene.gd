extends Node2D

export(String) var scene_to_load

onready var fade = $Fadein

func _on_LoadSceneArea_body_entered(body):
	fade.show()
	fade.fade_in()

func _on_Fadein_fade_finished():
	fade.hide()
	get_tree().change_scene(scene_to_load)

