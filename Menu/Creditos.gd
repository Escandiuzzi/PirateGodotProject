extends Control

onready var global = get_node("/root/Global");
func _ready():
	pass # Replace with function body.

func _on_Button_pressed():
	global.playButtonSound();
	get_tree().change_scene('res://MainMenu.tscn');
