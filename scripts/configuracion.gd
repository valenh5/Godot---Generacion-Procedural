extends Node2D

@onready var montania_button := $Control/OptionButton
@onready var arbol_button := $Control2/OptionButton

func _ready():
	montania_button.connect("item_selected", _on_option_button_item_selected)
	arbol_button.connect("item_selected2", _on_option_button_item_selected2)



func _on_aceptar_pressed():
	get_tree().change_scene_to_file("res://escenas/menu.tscn")


func _on_option_button_item_selected(index: int) -> void:
	Global.montania = montania_button.get_item_id(index)
	print("Montanias elegida:", Global.montania)


func _on_option_button_item_selected2(index: int) -> void:
	Global.arbol = arbol_button.get_item_id(index)
	print("Arbol elegido:", Global.arbol)
