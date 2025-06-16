extends Node2D



func _on_jugar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/World/world.tscn")

func _on_configuracion_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/configuracion.tscn")


func _on_sair_pressed() -> void:
	get_tree().quit()
