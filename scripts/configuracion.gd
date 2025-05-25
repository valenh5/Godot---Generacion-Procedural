extends Node2D

@onready var montania_button := $Control2/OptionButton
@onready var arbol_button := $Control2/OptionButton


func _ready():
	Global.montania = 1
	montania_button.connect("item_selected", _on_option_selected)

func _on_option_selected(index):
	Global.montania = index
	print("Montanias elegida:", Global.montania)

func _on_aceptar_pressed() -> void:
	get_tree().change_scene_to_file("res://escenas/menu.tscn")
