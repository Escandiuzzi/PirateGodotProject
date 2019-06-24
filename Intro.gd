extends Control

onready var global = get_node("/root/Global");
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Button_pressed():
	global.playButtonSound();
	get_tree().change_scene('res://MainMenu.tscn');


func _on_Button2_pressed():
	global.playButtonSound();
	get_tree().change_scene('res://World.tscn');
